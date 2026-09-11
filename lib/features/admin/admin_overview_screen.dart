import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/responsive.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/kpi_stat_card.dart';
import '../../widgets/status_badge.dart';
import 'widgets/admin_data_table.dart';
import 'widgets/trend_chart.dart';

class AdminOverviewScreen extends StatelessWidget {
  const AdminOverviewScreen({super.key});

  static const _weekLabels = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    final isDesktop = Responsive.isDesktop(context);
    final recentStations = MockData.stations.take(5).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: isDesktop ? null : AppBar(title: const Text('Genel Bakış')),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          isDesktop ? AppSpacing.xxl : AppSpacing.md,
          isDesktop ? AppSpacing.lg : AppSpacing.md,
          isDesktop ? AppSpacing.xxl : AppSpacing.md,
          AppSpacing.xxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDesktop) ...[
              Text('Genel Bakış', style: text.display),
              Text('Voltavia platformunun anlık özeti', style: text.bodyMuted),
              const Gap(AppSpacing.lg),
            ],
            _OverviewKpiGrid(isDesktop: isDesktop, colors: colors),
            const Gap(AppSpacing.lg),
            TrendChart(
              title: 'Kayıtlı Kullanıcı Büyümesi',
              subtitle: 'Son 7 gün',
              values: MockData.weeklyUserGrowth,
              labels: _weekLabels,
            ),
            const Gap(AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Son Eklenen İstasyonlar', style: text.title),
                TextButton(onPressed: () {}, child: const Text('Tümünü Gör')),
              ],
            ),
            const Gap(AppSpacing.sm),
            AdminDataTable(
              minWidth: isDesktop ? 0 : 640,
              columns: const [
                AdminTableColumn('İstasyon', flex: 3),
                AdminTableColumn('Şehir', flex: 2),
                AdminTableColumn('Operatör', flex: 2),
                AdminTableColumn('Durum', flex: 2),
              ],
              rows: [
                for (final station in recentStations)
                  [
                    Text(station.name, style: text.bodyStrong, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(station.city, style: text.bodyMuted),
                    Text(station.chargeOperator.name, style: text.bodyMuted),
                    StatusBadge(status: station.status, compact: true),
                  ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// KPI kartlarını, kartların doğal içerik yüksekliğine göre satırlar halinde
/// dizer — masaüstünde tek satırda 4, mobilde 2x2 — sabit bir en-boy oranının
/// yol açtığı boş alan yerine kartlar her zaman içeriğine göre boyutlanır.
class _OverviewKpiGrid extends StatelessWidget {
  final bool isDesktop;
  final AppSemanticColors colors;

  const _OverviewKpiGrid({required this.isDesktop, required this.colors});

  @override
  Widget build(BuildContext context) {
    final cards = [
      KpiStatCard(
        icon: Icons.place_rounded,
        label: 'Toplam İstasyon',
        value: '${MockData.stations.length}',
        trendLabel: '+%4.2 bu ay',
        trend: TrendDirection.up,
      ),
      KpiStatCard(
        icon: Icons.apartment_rounded,
        label: 'Aktif Operatör',
        value: '${MockData.operators.length}',
        trendLabel: '+2 yeni sözleşme',
        trend: TrendDirection.up,
        accent: colors.accentSecondary,
      ),
      KpiStatCard(
        icon: Icons.groups_rounded,
        label: 'Kayıtlı Kullanıcı',
        value: '86.4K',
        trendLabel: '+%11 bu ay',
        trend: TrendDirection.up,
        accent: colors.info,
      ),
      KpiStatCard(
        icon: Icons.storage_rounded,
        label: 'Veri Sürümü',
        value: 'v128',
        trendLabel: '3 gün önce',
        trend: TrendDirection.flat,
        accent: colors.warning,
      ),
    ];

    if (isDesktop) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < cards.length; i++) ...[
              if (i > 0) const Gap(AppSpacing.sm),
              Expanded(child: cards[i]),
            ],
          ],
        ),
      );
    }

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: cards[0]),
              const Gap(AppSpacing.sm),
              Expanded(child: cards[1]),
            ],
          ),
        ),
        const Gap(AppSpacing.sm),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: cards[2]),
              const Gap(AppSpacing.sm),
              Expanded(child: cards[3]),
            ],
          ),
        ),
      ],
    );
  }
}
