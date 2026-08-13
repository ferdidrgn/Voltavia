import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius_extension.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/station.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/station_card.dart';
import 'station_detail_screen.dart';
import 'widgets/city_filter_sheet.dart';

enum _SortBy { distance, price, power }

class StationListScreen extends StatefulWidget {
  const StationListScreen({super.key});

  @override
  State<StationListScreen> createState() => _StationListScreenState();
}

class _StationListScreenState extends State<StationListScreen> {
  String _query = '';
  String? _city;
  _SortBy _sort = _SortBy.distance;

  List<Station> get _filtered {
    var list = MockData.stations.where((s) {
      final matchesCity = _city == null || s.city == _city;
      final matchesQuery = _query.isEmpty ||
          s.name.toLowerCase().contains(_query.toLowerCase()) ||
          s.district.toLowerCase().contains(_query.toLowerCase());
      return matchesCity && matchesQuery;
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
    final city = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      builder: (_) => CityFilterSheet(selectedCity: _city),
    );
    if (!mounted) return;
    setState(() => _city = city);
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final stations = _filtered;

    return Scaffold(
      appBar: AppBar(title: const Text('İstasyonlar')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => _query = v),
                    decoration: const InputDecoration(
                      hintText: 'İstasyon veya ilçe ara',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Material(
                  color: _city != null
                      ? AppColors.brandPrimary
                      : context.voltaviaColors.surfaceElevated,
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
                        border: Border.all(color: context.voltaviaColors.border),
                      ),
                      child: Icon(
                        Icons.filter_list_rounded,
                        color: _city != null ? Colors.white : context.voltaviaColors.textMuted,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                if (_city != null)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xs),
                    child: Chip(
                      label: Text(_city!),
                      onDeleted: () => setState(() => _city = null),
                    ),
                  ),
                const Spacer(),
                DropdownButtonHideUnderline(
                  child: DropdownButton<_SortBy>(
                    value: _sort,
                    icon: const Icon(Icons.swap_vert_rounded, size: 18),
                    style: AppTextStyles.caption.copyWith(
                      color: context.voltaviaColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
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
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md, 0, AppSpacing.md, AppSpacing.lg,
                    ),
                    itemCount: stations.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, i) {
                      final station = stations[i];
                      return AnimatedBuilder(
                        animation: appState,
                        builder: (context, _) => StationCard(
                          station: station,
                          isFavorite: appState.isFavorite(station.id),
                          onFavoriteToggle: () => appState.toggleFavorite(station.id),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => StationDetailScreen(station: station)),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
