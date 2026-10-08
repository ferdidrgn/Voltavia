import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/responsive.dart';
import '../../data/models/connector_type.dart';
import '../../data/models/station.dart';
import '../../data/stations/station_query.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/station_card.dart';
import 'station_detail_screen.dart';
import 'widgets/city_filter_sheet.dart';
import 'widgets/station_filter_bar.dart';

enum _SortBy { distance, price, power }

class StationListScreen extends StatefulWidget {
  const StationListScreen({super.key});

  @override
  State<StationListScreen> createState() => _StationListScreenState();
}

class _StationListScreenState extends State<StationListScreen> {
  String _query = '';
  String? _city;
  String? _district;
  double? _maxKm;
  ConnectorType? _connector;
  double _minKw = 0;
  _SortBy _sort = _SortBy.distance;
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

  List<Station> get _filtered {
    final filter = DiscoveryFilter(connector: _connector, minKw: _minKw);
    var list = AppStateScope.of(context).stations.where((s) {
      return stationMatches(
        s,
        query: _query,
        city: _city,
        district: _district,
        maxDistanceKm: _maxKm,
        filter: filter,
      );
    }).toList();

    switch (_sort) {
      case _SortBy.distance:
        list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
        break;
      case _SortBy.price:
        list.sort((a, b) => a.pricePerKwh.compareTo(b.pricePerKwh));
        break;
      case _SortBy.power:
        list.sort((a, b) => b.maxPowerKw.compareTo(a.maxPowerKw));
        break;
    }
    return list;
  }

  Future<void> _openCityFilter() async {
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
  }

  Future<void> _near() async {
    if (_maxKm != null) {
      setState(() => _maxKm = null);
      return;
    }
    final appState = AppStateScope.of(context);
    await appState.requestDeviceLocation();
    if (!mounted) return;
    if (appState.deviceLatitude == null) return;
    setState(() => _maxKm = 30);
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final colors = context.colors;
    final stations = _filtered;
    final isDesktop = Responsive.isDesktop(context);
    final columns = Responsive.gridColumns(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: isDesktop ? null : AppBar(title: const Text('İstasyonlar')),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
          child: Column(
            children: [
              if (isDesktop)
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.lg, AppSpacing.xxl, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('İstasyonlar', style: context.text.display),
                  ),
                ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isDesktop ? AppSpacing.xxl : AppSpacing.md,
                  AppSpacing.md,
                  isDesktop ? AppSpacing.xxl : AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (v) => setState(() => _query = v),
                        decoration: InputDecoration(
                          hintText: 'İstasyon, ilçe veya işletmeci',
                          prefixIcon: Icon(Icons.search_rounded, size: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Material(
                      color: _city != null ? colors.accentPrimary : colors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        onTap: _openCityFilter,
                        child: Container(
                          width: 48,
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(color: colors.border),
                          ),
                          child: Icon(
                            Icons.filter_list_rounded,
                            size: 19,
                            color: _city != null ? Colors.white : colors.textMuted,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isDesktop ? AppSpacing.xxl : AppSpacing.md,
                  0,
                  isDesktop ? AppSpacing.xxl : AppSpacing.md,
                  AppSpacing.xs,
                ),
                child: Column(
                  children: [
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
                      onPickPlace: _openCityFilter,
                      onNear: _near,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? AppSpacing.xxl : AppSpacing.md),
                child: Row(
                  children: [
                    if (_city != null)
                      Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.xs),
                        child: Chip(
                          label: Text(_district == null ? _city! : '$_district, $_city'),
                          onDeleted: () => setState(() {
                            _city = null;
                            _district = null;
                          }),
                        ),
                      ),
                    const Spacer(),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<_SortBy>(
                        value: _sort,
                        icon: Icon(Icons.swap_vert_rounded, size: 15),
                        style: context.text.caption.copyWith(fontWeight: FontWeight.w600),
                        items: const [
                          DropdownMenuItem(value: _SortBy.distance, child: Text('Mesafeye göre')),
                          DropdownMenuItem(value: _SortBy.price, child: Text('Fiyata göre')),
                          DropdownMenuItem(value: _SortBy.power, child: Text('Güce göre')),
                        ],
                        onChanged: (v) => setState(() => _sort = v ?? _sort),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Expanded(
                child: stations.isEmpty
                    ? Center(
                        child: EmptyState(
                          icon: Icons.search_off_rounded,
                          title: 'İstasyon bulunamadı',
                          message: 'Aramanı ya da filtreni değiştirip tekrar dene.',
                        ),
                      )
                    : AnimatedBuilder(
                        animation: appState,
                        builder: (context, _) => isDesktop
                            ? GridView.builder(
                                padding: const EdgeInsets.fromLTRB(
                                  AppSpacing.xxl, 0, AppSpacing.xxl, AppSpacing.xxl,
                                ),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: columns,
                                  mainAxisSpacing: AppSpacing.sm,
                                  crossAxisSpacing: AppSpacing.sm,
                                  childAspectRatio: 1.7,
                                ),
                                itemCount: stations.length,
                                itemBuilder: (context, i) => _card(stations[i], appState, i),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.fromLTRB(
                                  AppSpacing.md, 0, AppSpacing.md, AppSpacing.lg,
                                ),
                                itemCount: stations.length,
                                separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                                itemBuilder: (context, i) => _card(stations[i], appState, i),
                              ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(Station station, AppState appState, int index) {
    return StationCard(
      station: station,
      index: index,
      isFavorite: appState.isFavorite(station.id),
      onFavoriteToggle: () => appState.toggleFavorite(station.id),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => StationDetailScreen(station: station)),
      ),
    );
  }
}
