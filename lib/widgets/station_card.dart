import 'package:flutter/material.dart';

import '../core/theme/app_motion.dart';
import '../core/theme/app_palette.dart';
import '../core/theme/app_semantic_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../core/utils/formatters.dart';
import '../data/models/station.dart';
import 'bento_card.dart';
import 'connector_chip.dart';
import 'status_badge.dart';

class StationCard extends StatelessWidget {
  final Station station;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;
  final int index;

  const StationCard({
    super.key,
    required this.station,
    required this.onTap,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;

    return BentoCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      glowColor: colors.accentPrimary,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: AppPalette.indigoGradient,
                ),
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(AppRadius.xl)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: AppPalette.indigoGradient),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            boxShadow: [
                              BoxShadow(color: colors.accentPrimary.withValues(alpha: 0.35), blurRadius: 14, offset: const Offset(0, 6)),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            station.chargeOperator.logoLetter,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 19),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                station.name,
                                style: text.bodyStrong.copyWith(fontSize: 15.5),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${station.district}, ${station.city} · ${station.chargeOperator.name}',
                                style: text.captionMuted,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: onFavoriteToggle,
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                              icon: Icon(
                                isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                color: isFavorite ? colors.danger : colors.textMuted,
                                size: 20,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: colors.accentPrimary.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(AppRadius.xs),
                              ),
                              child: Text(
                                '${Formatters.tryPrice(station.pricePerKwh)}/kWh',
                                style: text.caption.copyWith(color: colors.accentPrimary, fontWeight: FontWeight.w800, fontSize: 11.5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: station.connectors.map((c) => ConnectorChip(type: c)).toList(),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        StatusBadge(status: station.status, compact: true),
                        const SizedBox(width: AppSpacing.sm),
                        Icon(Icons.bolt_rounded, size: 14, color: colors.textMuted),
                        const SizedBox(width: 2),
                        Text('${station.maxPowerKw.toStringAsFixed(0)} kW', style: text.captionMuted),
                        const SizedBox(width: AppSpacing.sm),
                        Icon(Icons.place_rounded, size: 14, color: colors.textMuted),
                        const SizedBox(width: 2),
                        Text(Formatters.km(station.distanceKm), style: text.captionMuted),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).enterRise(delay: AppMotion.staggerDelay(index));
  }
}
