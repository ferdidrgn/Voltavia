import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/connector_type.dart';
import '../../../data/models/station.dart';
import '../../../widgets/plug_mark.dart';

/// Ana sayfanın ilk sahnesi: soket yüzü ve en yakın istasyon.
/// Eşit KPI kartlarının önüne geçer; büyük sayı yerine fiziksel motif durur.
class NearestChargeStage extends StatelessWidget {
  final Station station;
  final VoidCallback onOpen;
  final Widget? trailing;

  const NearestChargeStage({
    super.key,
    required this.station,
    required this.onOpen,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    final progress = switch (station.status) {
      StationStatus.available => 0.78,
      StationStatus.busy => 0.46,
      StationStatus.maintenance => 0.22,
      StationStatus.offline => 0.12,
      StationStatus.unknown => 0.4,
    };

    return Material(
      color: colors.surface.withValues(alpha: colors.isDark ? 0.88 : 0.92),
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onOpen,
        child: Container(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: colors.borderStrong),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text('En yakın soket', style: text.bodyMuted)),
                  ?trailing,
                ],
              ),
              const Gap(AppSpacing.sm),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PlugMark(size: 108, progress: progress),
                  const Gap(AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          station.name,
                          style: text.headline,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Gap(AppSpacing.xxs),
                        Text(
                          '${station.district}, ${station.city}',
                          style: text.bodyMuted,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Gap(AppSpacing.sm),
                        Text(
                          '${Formatters.km(station.distanceKm)} · ${station.maxPowerKw.toStringAsFixed(0)} kW',
                          style: text.bodyStrong,
                        ),
                        const Gap(AppSpacing.md),
                        FilledButton(
                          onPressed: onOpen,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppPalette.sodium,
                            foregroundColor: AppPalette.ink,
                            minimumSize: const Size(48, 48),
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                          ),
                          child: const Text('Haritada aç'),
                        ),
                      ],
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
