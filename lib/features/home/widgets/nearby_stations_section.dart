import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius_extension.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/station.dart';
import '../../../widgets/map_grid_background.dart';
import '../../../widgets/status_badge.dart';
import '../../stations/station_detail_screen.dart';

/// "Sana en yakın istasyonlar" bölümü: haritaya götüren büyük bir CTA kartı +
/// mesafeye göre sıralanmış yatay kaydırmalı istasyon önizlemeleri.
class NearbyStationsSection extends StatelessWidget {
  final List<Station> stations;
  final VoidCallback onOpenMap;

  const NearbyStationsSection({super.key, required this.stations, required this.onOpenMap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            onTap: onOpenMap,
            child: Container(
              height: 108,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.lg)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MapGridBackground(
                    baseColor: isDark ? const Color(0xFF141B34) : const Color(0xFFE9EDFB),
                    lineColor: isDark ? Colors.white : AppColors.brandPrimary,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          (isDark ? AppColors.darkBackground : Colors.white).withValues(alpha: 0.92),
                          (isDark ? AppColors.darkBackground : Colors.white).withValues(alpha: 0.15),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Sana En Yakın Noktalar', style: AppTextStyles.bodyStrong),
                              const SizedBox(height: 2),
                              Text(
                                stations.isEmpty
                                    ? 'Haritada istasyonları keşfet'
                                    : '${Formatters.km(stations.first.distanceKm)} uzaklıkta istasyon var',
                                style: AppTextStyles.caption.copyWith(color: context.voltaviaColors.textMuted),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Haritada Gör',
                                    style: TextStyle(
                                      color: AppColors.brandPrimary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.arrow_forward_rounded,
                                      size: 15, color: AppColors.brandPrimary),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: AppColors.brandPrimary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.near_me_rounded, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: stations.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, i) {
              final station = stations[i];
              return _NearbyCard(
                station: station,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => StationDetailScreen(station: station)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NearbyCard extends StatelessWidget {
  final Station station;
  final VoidCallback onTap;

  const _NearbyCard({required this.station, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final muted = context.voltaviaColors.textMuted;
    return SizedBox(
      width: 180,
      child: Material(
        color: context.voltaviaColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: context.voltaviaColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        station.name,
                        style: AppTextStyles.bodyStrong.copyWith(fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  station.chargeOperator.name,
                  style: AppTextStyles.caption.copyWith(color: muted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  children: [
                    StatusBadge(status: station.status, compact: true),
                    const Spacer(),
                    Icon(Icons.place_outlined, size: 13, color: muted),
                    const SizedBox(width: 2),
                    Text(Formatters.km(station.distanceKm), style: AppTextStyles.caption.copyWith(color: muted)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
