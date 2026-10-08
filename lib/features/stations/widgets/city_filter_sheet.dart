import 'package:flutter/material.dart';

import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/state/app_state.dart';
import '../../../data/stations/station_query.dart';
import '../../../data/stations/turkey_provinces.dart';

/// Şehir/ilçe filtresi için modal alt sayfa (bottom sheet).
class CityFilterSheet extends StatefulWidget {
  final String? selectedCity;
  final String? selectedDistrict;

  const CityFilterSheet({super.key, this.selectedCity, this.selectedDistrict});

  @override
  State<CityFilterSheet> createState() => _CityFilterSheetState();
}

class _CityFilterSheetState extends State<CityFilterSheet> {
  String? _city;
  String? _district;
  String _cityQuery = '';

  @override
  void initState() {
    super.initState();
    _city = widget.selectedCity;
    _district = widget.selectedDistrict;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    final stations = AppStateScope.of(context).stations;
    final cities = stations.map((s) => s.city).where((c) => c.isNotEmpty).toSet().toList()..sort();
    final needle = foldTr(_cityQuery);
    final shownCities = needle.isEmpty ? cities : cities.where((city) => foldTr(city).contains(needle)).toList();
    final districts = _city == null
        ? <String>[]
        : stations.where((s) => s.city == _city && s.district.isNotEmpty).map((s) => s.district).toSet().toList()
      ..sort();

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.sm),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: colors.border, borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('İl / İlçe', style: text.headline),
                  TextButton(
                    onPressed: () => setState(() {
                      _city = null;
                      _district = null;
                    }),
                    child: const Text('Temizle'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                onChanged: (value) => setState(() => _cityQuery = value),
                decoration: const InputDecoration(
                  hintText: 'İl ara',
                  prefixIcon: Icon(Icons.search_rounded, size: 18),
                  isDense: true,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    Text('İl', style: text.title),
                    const SizedBox(height: AppSpacing.xs),
                    if (shownCities.isEmpty)
                      Text('Bu adla il yok', style: text.captionMuted)
                    else
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: shownCities.map((city) {
                        final selected = city == _city;
                        return ChoiceChip(
                          label: Text(city),
                          selected: selected,
                          onSelected: (_) => setState(() {
                            _city = selected ? null : city;
                            _district = null;
                          }),
                          selectedColor: colors.accentPrimary,
                          labelStyle: TextStyle(
                            color: selected ? Colors.white : null,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList(),
                    ),
                    if (districts.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Text('İlçe', style: text.title),
                      const SizedBox(height: AppSpacing.xs),
                      Wrap(
                        spacing: AppSpacing.xs,
                        runSpacing: AppSpacing.xs,
                        children: districts.map((d) {
                          final selected = d == _district;
                          return ChoiceChip(
                            label: Text(d),
                            selected: selected,
                            onSelected: (_) => setState(() => _district = selected ? null : d),
                            selectedColor: colors.accentPrimary,
                            labelStyle: TextStyle(
                              color: selected ? Colors.white : null,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(PlaceSelection(city: _city, district: _district)),
                  child: const Text('Uygula'),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        );
      },
    );
  }
}
