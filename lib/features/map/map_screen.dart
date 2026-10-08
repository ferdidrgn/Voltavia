import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/connector_type.dart';
import '../../data/models/station.dart';
import '../../data/stations/station_query.dart';
import '../../data/stations/turkey_provinces.dart';
import '../stations/widgets/city_filter_sheet.dart';
import '../stations/widgets/station_filter_bar.dart';
import '../../widgets/status_badge.dart';
import '../stations/station_detail_screen.dart';
import 'station_map.dart';

/// Geniş ekranda solda liste, sağda harita. Dar ekranda harita tam sayfa.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _mapController = MapController();
  final _query = TextEditingController();
  String _queryText = '';
  ConnectorType? _connector;
  double _minKw = 0;
  String? _city;
  String? _district;
  double? _maxKm;
  Station? _selected;
  bool _syncedVehicle = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_syncedVehicle) return;
    final vehicle = AppStateScope.of(context).defaultVehicle;
    if (vehicle == null) return;
    _syncedVehicle = true;
    _connector = vehicle.connector;
  }

  @override
  void dispose() {
    _query.dispose();
    _mapController.dispose();
    super.dispose();
  }

  List<Station> _visible(List<Station> all) {
    final filter = DiscoveryFilter(connector: _connector, minKw: _minKw);
    return all.where((station) {
      return stationMatches(
        station,
        query: _queryText,
        city: _city,
        district: _district,
        maxDistanceKm: _maxKm,
        filter: filter,
      );
    }).toList();
  }

  Future<void> _pickPlace() async {
    final selection = await showModalBottomSheet<PlaceSelection>(
      context: context,
      isScrollControlled: true,
      builder: (_) => CityFilterSheet(selectedCity: _city, selectedDistrict: _district),
    );
    if (!mounted || selection == null) return;
    setState(() {
      _city = selection.city;
      _district = selection.district;
    });
    final city = selection.city;
    if (city == null) return;
    final province = provinceByName(city);
    if (province == null) return;
    final zoom = selection.district == null ? 9.0 : 12.0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _mapController.move(LatLng(province.latitude, province.longitude), zoom);
    });
  }

  Future<void> _near() async {
    if (_maxKm != null) {
      setState(() => _maxKm = null);
      return;
    }
    final appState = AppStateScope.of(context);
    await appState.requestDeviceLocation();
    if (!mounted) return;
    final lat = appState.deviceLatitude;
    final lon = appState.deviceLongitude;
    if (lat == null || lon == null) return;
    setState(() => _maxKm = 30);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _mapController.move(LatLng(lat, lon), 12);
    });
  }

  void _focus(Station station) {
    setState(() => _selected = station);
    _mapController.move(LatLng(station.latitude, station.longitude), 14);
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final colors = context.colors;
    final text = context.text;
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= 900;
    final stations = _visible(appState.stations);

    final map = StationMap(
      controller: _mapController,
      stations: stations,
      selected: _selected,
      onSelect: _focus,
    );

    final list = _StationRail(
      stations: stations,
      selected: _selected,
      loading: appState.stationsLoading,
      live: appState.usingLiveStations,
      query: _query,
      onQuery: (value) => setState(() => _queryText = value),
      onSelect: _focus,
      connector: _connector,
      minKw: _minKw,
      onConnector: (value) => setState(() => _connector = value),
      onMinKw: (value) => setState(() => _minKw = value),
      city: _city,
      district: _district,
      maxKm: _maxKm,
      onPickPlace: _pickPlace,
      onNear: _near,
    );

    if (!wide) {
      return Scaffold(
        backgroundColor: colors.canvas,
        body: Stack(
          children: [
            Positioned.fill(child: map),
            Positioned(
              left: AppSpacing.md,
              right: AppSpacing.md,
              top: AppSpacing.md,
              child: SafeArea(
                child: Material(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _SearchField(controller: _query, onChanged: (v) => setState(() => _queryText = v)),
                        const SizedBox(height: AppSpacing.xs),
                        StationFilterBar(
                          connector: _connector,
                          minKw: _minKw,
                          onConnector: (value) => setState(() => _connector = value),
                          onMinKw: (value) => setState(() => _minKw = value),
                        ),
                        PlaceFilterBar(
                          city: _city,
                          district: _district,
                          maxDistanceKm: _maxKm,
                          onPickPlace: _pickPlace,
                          onNear: _near,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (_selected != null)
              Positioned(
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom: AppSpacing.md,
                child: _SelectedCard(station: _selected!, onOpen: () => _open(context, _selected!)),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: colors.canvas,
      body: Row(
        children: [
          SizedBox(width: 380, child: Material(color: colors.surface, child: list)),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
                  child: Row(
                    children: [
                      Expanded(child: Text('Türkiye şarj haritası', style: text.headline)),
                      Text(
                        appState.stationsLoading
                            ? 'Kayıtlar yükleniyor'
                            : stations.isEmpty
                                ? 'Katalog boş'
                                : _sourceLine(stations),
                        style: text.captionMuted,
                      ),
                    ],
                  ),
                ),
                Expanded(child: map),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _open(BuildContext context, Station station) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => StationDetailScreen(station: station)));
  }
}

String _sourceLine(List<Station> stations) {
  var epdk = 0;
  var osm = 0;
  var both = 0;
  for (final station in stations) {
    if (station.origin.contains('+')) {
      both++;
    } else if (station.origin.startsWith('EPDK')) {
      epdk++;
    } else if (station.origin == 'OpenStreetMap') {
      osm++;
    }
  }
  if (epdk == 0 && osm == 0 && both == 0) return '${stations.length} nokta';
  return '$epdk EPDK · $osm OpenStreetMap · $both ortak';
}

class _StationRail extends StatelessWidget {
  final List<Station> stations;
  final Station? selected;
  final bool loading;
  final bool live;
  final TextEditingController query;
  final ValueChanged<String> onQuery;
  final ValueChanged<Station> onSelect;
  final ConnectorType? connector;
  final double minKw;
  final ValueChanged<ConnectorType?> onConnector;
  final ValueChanged<double> onMinKw;
  final String? city;
  final String? district;
  final double? maxKm;
  final VoidCallback onPickPlace;
  final VoidCallback onNear;

  const _StationRail({
    required this.stations,
    required this.selected,
    required this.loading,
    required this.live,
    required this.query,
    required this.onQuery,
    required this.onSelect,
    required this.connector,
    required this.minKw,
    required this.onConnector,
    required this.onMinKw,
    required this.city,
    required this.district,
    required this.maxKm,
    required this.onPickPlace,
    required this.onNear,
  });

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.lg, AppSpacing.md, AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(live ? 'EPDK ve OpenStreetMap' : 'Kayıtlı katalog', style: text.title),
              const SizedBox(height: 4),
              Text(
                loading ? 'EPDK ve OpenStreetMap sorgulanıyor' : _sourceLine(stations),
                style: text.captionMuted,
              ),
              const SizedBox(height: AppSpacing.sm),
              _SearchField(controller: query, onChanged: onQuery),
              const SizedBox(height: AppSpacing.xs),
              StationFilterBar(
                connector: connector,
                minKw: minKw,
                onConnector: onConnector,
                onMinKw: onMinKw,
              ),
              PlaceFilterBar(
                city: city,
                district: district,
                maxDistanceKm: maxKm,
                onPickPlace: onPickPlace,
                onNear: onNear,
              ),
            ],
          ),
        ),
        if (loading) const LinearProgressIndicator(minHeight: 2),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.xs, AppSpacing.sm, AppSpacing.lg),
            itemCount: stations.length,
            separatorBuilder: (_, _) => const SizedBox(height: 4),
            itemBuilder: (context, index) {
              final station = stations[index];
              final active = station.id == selected?.id;
              return Material(
                color: active ? colors.accentPrimary.withValues(alpha: 0.12) : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  onTap: () => onSelect(station),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(station.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: text.bodyStrong),
                              const SizedBox(height: 2),
                              Text(
                                '${station.origin} · ${station.city}${station.district.isEmpty ? '' : ' · ${station.district}'} · ${Formatters.km(station.distanceKm)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: text.captionMuted,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        StatusBadge(status: station.status),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: const InputDecoration(
        hintText: 'İstasyon, şehir veya işletmeci',
        prefixIcon: Icon(Icons.search_rounded, size: 20),
        isDense: true,
      ),
    );
  }
}

class _SelectedCard extends StatelessWidget {
  final Station station;
  final VoidCallback onOpen;

  const _SelectedCard({required this.station, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    return Material(
      color: colors.surface,
      elevation: 8,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(station.name, style: text.bodyStrong, maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(
                      '${station.origin} · ${station.chargeOperator.name} · ${Formatters.km(station.distanceKm)}',
                      style: text.captionMuted,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
