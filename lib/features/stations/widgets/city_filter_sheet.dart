import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius_extension.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/mock/mock_data.dart';

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

  @override
  void initState() {
    super.initState();
    _city = widget.selectedCity;
    _district = widget.selectedDistrict;
  }

  @override
  Widget build(BuildContext context) {
    final muted = context.voltaviaColors.textMuted;
    final districts = _city == null ? <String>[] : MockData.districtsFor(_city!);

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
                  decoration: BoxDecoration(
                    color: context.voltaviaColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Şehir / İlçe Seç', style: AppTextStyles.headline),
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
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    Text('ŞEHİR', style: AppTextStyles.overline.copyWith(color: muted)),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: MockData.cities.map((city) {
                        final selected = city == _city;
                        return ChoiceChip(
                          label: Text(city),
                          selected: selected,
                          onSelected: (_) => setState(() {
                            _city = selected ? null : city;
                            _district = null;
                          }),
                          selectedColor: AppColors.brandPrimary,
                          labelStyle: TextStyle(
                            color: selected ? Colors.white : null,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList(),
                    ),
                    if (districts.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Text('İLÇE', style: AppTextStyles.overline.copyWith(color: muted)),
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
                            selectedColor: AppColors.brandPrimary,
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
                  onPressed: () => Navigator.of(context).pop(_city),
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
