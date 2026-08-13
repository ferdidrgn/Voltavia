import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_radius_extension.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../core/utils/formatters.dart';
import '../data/models/station.dart';
import 'connector_chip.dart';
import 'status_badge.dart';

class StationCard extends StatelessWidget {
  final Station station;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;

  const StationCard({
    super.key,
    required this.station,
    required this.onTap,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final muted = context.voltaviaColors.textMuted;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Padding(
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
                      gradient: const LinearGradient(colors: AppColors.energyGradient),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      station.chargeOperator.logoLetter,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          station.name,
                          style: AppTextStyles.bodyStrong,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${station.district}, ${station.city} · ${station.chargeOperator.name}',
                          style: AppTextStyles.caption.copyWith(color: muted),
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
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? AppColors.statusBusy : muted,
                      size: 22,
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
                  Icon(Icons.bolt, size: 15, color: muted),
                  const SizedBox(width: 2),
                  Text('${station.maxPowerKw.toStringAsFixed(0)} kW',
                      style: AppTextStyles.caption.copyWith(color: muted)),
                  const SizedBox(width: AppSpacing.sm),
                  Icon(Icons.place_outlined, size: 15, color: muted),
                  const SizedBox(width: 2),
                  Text(Formatters.km(station.distanceKm),
                      style: AppTextStyles.caption.copyWith(color: muted)),
                  const Spacer(),
                  Text(
                    '${Formatters.tryPrice(station.pricePerKwh)}/kWh',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.brandPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
