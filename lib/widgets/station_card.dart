import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

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
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: AppPalette.indigoGradient),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                alignment: Alignment.center,
                child: Text(
                  station.chargeOperator.logoLetter,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      station.name,
                      style: text.bodyStrong,
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
              IconButton(
                onPressed: onFavoriteToggle,
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: isFavorite ? colors.danger : colors.textMuted,
                  size: 20,
                ),
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
              Icon(LucideIcons.zap, size: 14, color: colors.textMuted),
              const SizedBox(width: 2),
              Text('${station.maxPowerKw.toStringAsFixed(0)} kW', style: text.captionMuted),
              const SizedBox(width: AppSpacing.sm),
              Icon(LucideIcons.mapPin, size: 14, color: colors.textMuted),
              const SizedBox(width: 2),
              Text(Formatters.km(station.distanceKm), style: text.captionMuted),
              const Spacer(),
              Text(
                '${Formatters.tryPrice(station.pricePerKwh)}/kWh',
                style: text.caption.copyWith(color: colors.accentPrimary, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    ).enterRise(delay: AppMotion.staggerDelay(index));
  }
}
