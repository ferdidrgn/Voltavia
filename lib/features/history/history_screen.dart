import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/charging_session.dart';
import '../../widgets/bento_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/kpi_stat_card.dart';

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
                icon: LucideIcons.history,
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
                      child: KpiStatCard(icon: LucideIcons.zap, label: 'Toplam Enerji', value: Formatters.kwh(totalKwh)),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: KpiStatCard(
                        icon: LucideIcons.creditCard,
                        label: 'Toplam Harcama',
                        value: Formatters.tryPrice(totalCost),
                        accent: context.colors.accentSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                ...sessions.map((s) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _SessionTile(session: s),
                    )),
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
    final colors = context.colors;
    final text = context.text;
    final isStopped = session.state == SessionState.stopped;
    final accent = isStopped ? colors.warning : colors.accentPrimary;

    return BentoCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: accent.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(AppRadius.sm)),
            child: Icon(
              isStopped ? Icons.pause_circle_outline : Icons.check_circle_outline,
              color: accent,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session.stationName, style: text.bodyStrong),
                const SizedBox(height: 2),
                Text(
                  '${Formatters.dateTime(session.startedAt)} · ${Formatters.kwh(session.energyKwh)}',
                  style: text.captionMuted,
                ),
              ],
            ),
          ),
          Text(Formatters.tryPrice(session.costTry), style: text.bodyStrong.copyWith(color: colors.accentPrimary)),
        ],
      ),
    );
  }
}
