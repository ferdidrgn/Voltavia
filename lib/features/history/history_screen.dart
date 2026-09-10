import 'package:flutter/material.dart';

import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/responsive.dart';
import '../../core/utils/formatters.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/charging_session.dart';
import '../../widgets/bento_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/kpi_stat_card.dart';

/// Bir kWh elektrikli şarj yerine ortalama bir benzinli aracın ürettiği
/// tahmini CO2 farkı — TÜİK/AB ortalama şebeke emisyon faktörlerine dayanan
/// kabaca bir tahmindir, kesin bir ölçüm değildir.
const _co2SavedPerKwh = 0.65;

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessions = MockData.history;
    final totalKwh = sessions.fold<double>(0, (sum, s) => sum + s.energyKwh);
    final totalCost = sessions.fold<double>(0, (sum, s) => sum + s.costTry);
    final co2Saved = totalKwh * _co2SavedPerKwh;
    final isDesktop = Responsive.isDesktop(context);

    final content = sessions.isEmpty
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
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: KpiStatCard(
                        icon: Icons.bolt_rounded,
                        label: 'Toplam Enerji',
                        value: Formatters.kwh(totalKwh),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: KpiStatCard(
                        icon: Icons.credit_card_rounded,
                        label: 'Toplam Harcama',
                        value: Formatters.tryPrice(totalCost),
                        accent: context.colors.accentSecondary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: KpiStatCard(
                        icon: Icons.eco_rounded,
                        label: 'CO2 Tasarrufu',
                        value: '${co2Saved.toStringAsFixed(0)} kg',
                        accent: context.colors.success,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ...sessions.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _SessionTile(session: s),
                  )),
            ],
          );

    return Scaffold(
      appBar: AppBar(title: const Text('Şarj Geçmişi')),
      body: isDesktop
          ? Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
                child: content,
              ),
            )
          : content,
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
