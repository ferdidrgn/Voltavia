import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/station.dart';
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
  Station? _selected;

  @override
  void dispose() {
    _query.dispose();
    _mapController.dispose();
    super.dispose();
  }

  List<Station> _visible(List<Station> all) {
    final q = _queryText.trim().toLowerCase();
    if (q.isEmpty) return all;
    return all.where((s) {
      return s.name.toLowerCase().contains(q) ||
          s.city.toLowerCase().contains(q) ||
          s.district.toLowerCase().contains(q) ||
          s.chargeOperator.name.toLowerCase().contains(q);
    }).toList();
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
              child: SafeArea(child: _SearchField(controller: _query, onChanged: (v) => setState(() => _queryText = v))),
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
                            : appState.usingLiveStations
                                ? _sourceLine(stations)
                                : '${stations.length} örnek nokta',
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

  const _StationRail({
    required this.stations,
    required this.selected,
    required this.loading,
    required this.live,
    required this.query,
    required this.onQuery,
    required this.onSelect,
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
              Text(live ? 'EPDK ve OpenStreetMap' : 'Örnek istasyonlar', style: text.title),
              const SizedBox(height: 4),
              Text(
                loading ? 'EPDK ve OpenStreetMap sorgulanıyor' : _sourceLine(stations),
                style: text.captionMuted,
              ),
              const SizedBox(height: AppSpacing.sm),
              _SearchField(controller: query, onChanged: onQuery),
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
