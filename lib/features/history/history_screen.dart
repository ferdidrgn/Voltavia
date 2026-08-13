import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius_extension.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/charging_session.dart';
import '../../widgets/empty_state.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessions = MockData.history;
    final totalKwh = sessions.fold<double>(0, (sum, s) => sum + s.energyKwh);
    final totalCost = sessions.fold<double>(0, (sum, s) => sum + s.costTry);

    return Scaffold(
      appBar: AppBar(title: const Text('Şarj Geçmişi')),
      body: sessions.isEmpty
          ? Center(
              child: EmptyState(
                icon: Icons.history_rounded,
                title: 'Henüz şarj geçmişin yok',
                message: 'Bir şarj oturumu tamamladığında burada listelenecek.',
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _SummaryTile(
                        label: 'Toplam Enerji',
                        value: Formatters.kwh(totalKwh),
                        icon: Icons.electric_bolt_outlined,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _SummaryTile(
                        label: 'Toplam Harcama',
                        value: Formatters.tryPrice(totalCost),
                        icon: Icons.payments_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                ...sessions.map((s) => _SessionTile(session: s)),
              ],
            ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SummaryTile({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final muted = context.voltaviaColors.textMuted;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.voltaviaColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.voltaviaColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.brandPrimary),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: AppTextStyles.headline),
          Text(label, style: AppTextStyles.caption.copyWith(color: muted)),
        ],
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  final ChargingSession session;

  const _SessionTile({required this.session});

  @override
  Widget build(BuildContext context) {
    final muted = context.voltaviaColors.textMuted;
    final isStopped = session.state == SessionState.stopped;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.voltaviaColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.voltaviaColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (isStopped ? AppColors.statusMaintenance : AppColors.brandPrimary)
                  .withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              isStopped ? Icons.pause_circle_outline : Icons.check_circle_outline,
              color: isStopped ? AppColors.statusMaintenance : AppColors.brandPrimary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session.stationName, style: AppTextStyles.bodyStrong),
                const SizedBox(height: 2),
                Text(
                  '${Formatters.dateTime(session.startedAt)} · ${Formatters.kwh(session.energyKwh)}',
                  style: AppTextStyles.caption.copyWith(color: muted),
                ),
              ],
            ),
          ),
          Text(
            Formatters.tryPrice(session.costTry),
            style: AppTextStyles.bodyStrong.copyWith(color: AppColors.brandPrimary),
          ),
        ],
      ),
    );
  }
}
