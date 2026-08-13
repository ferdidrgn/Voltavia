import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius_extension.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/operator.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/station_card.dart';
import '../stations/station_detail_screen.dart';

class OperatorDetailScreen extends StatelessWidget {
  final ChargeOperator chargeOperator;

  const OperatorDetailScreen({super.key, required this.chargeOperator});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final muted = context.voltaviaColors.textMuted;
    final stations = MockData.stationsFor(chargeOperator.id);

    return Scaffold(
      appBar: AppBar(title: Text(chargeOperator.name)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: AppColors.energyGradient),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                alignment: Alignment.center,
                child: Text(
                  chargeOperator.logoLetter,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 26),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(chargeOperator.name, style: AppTextStyles.displayMd),
                    const SizedBox(height: 4),
                    Text('${stations.length} istasyon', style: AppTextStyles.body.copyWith(color: muted)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (chargeOperator.hasAppIntegration)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: context.voltaviaColors.success.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: context.voltaviaColors.success.withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified_rounded, size: 16, color: context.voltaviaColors.success),
                  const SizedBox(width: 6),
                  Text(
                    'Voltavia ile uygulama içi şarj destekleniyor',
                    style: AppTextStyles.caption.copyWith(
                      color: context.voltaviaColors.success,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            chargeOperator.description.isEmpty
                ? 'Bu operatör hakkında henüz bir açıklama eklenmedi.'
                : chargeOperator.description,
            style: AppTextStyles.body.copyWith(color: muted, height: 1.6),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('İstasyonları', style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.sm),
          if (stations.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: EmptyState(
                icon: Icons.ev_station_outlined,
                title: 'Henüz istasyon yok',
                message: 'Bu operatörün istasyonları yakında Voltavia haritasında görünecek.',
              ),
            )
          else
            AnimatedBuilder(
              animation: appState,
              builder: (context, _) => Column(
                children: stations
                    .map((station) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: StationCard(
                            station: station,
                            isFavorite: appState.isFavorite(station.id),
                            onFavoriteToggle: () => appState.toggleFavorite(station.id),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => StationDetailScreen(station: station)),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
