import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/station.dart';
import '../../../widgets/bento_card.dart';
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
    final colors = context.colors;
    final text = context.text;

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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: colors.border),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MapGridBackground(baseColor: colors.surface, lineColor: colors.accentPrimary),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [colors.canvas.withValues(alpha: 0.92), colors.canvas.withValues(alpha: 0.1)],
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
                              Text('Sana En Yakın Noktalar', style: text.bodyStrong),
                              const SizedBox(height: 2),
                              Text(
                                stations.isEmpty
                                    ? 'Haritada istasyonları keşfet'
                                    : '${Formatters.km(stations.first.distanceKm)} uzaklıkta istasyon var',
                                style: text.captionMuted,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Haritada Gör',
                                    style: TextStyle(
                                      color: colors.accentPrimary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(LucideIcons.arrowRight, size: 15, color: colors.accentPrimary),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: AppPalette.indigoGradient),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.navigation, color: Colors.white, size: 19),
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
          height: 100,
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
    final colors = context.colors;
    final text = context.text;
    return SizedBox(
      width: 180,
      child: BentoCard(
        onTap: onTap,
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              station.name,
              style: text.bodyStrong.copyWith(fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              station.chargeOperator.name,
              style: text.captionMuted,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              children: [
                StatusBadge(status: station.status, compact: true),
                const Spacer(),
                Icon(LucideIcons.mapPin, size: 13, color: colors.textMuted),
                const SizedBox(width: 2),
                Text(Formatters.km(station.distanceKm), style: text.captionMuted),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
