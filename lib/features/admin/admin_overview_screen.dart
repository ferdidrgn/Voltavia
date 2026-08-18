import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons/lucide_icons.dart';

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
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isDesktop ? 4 : 2,
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              childAspectRatio: isDesktop ? 1.35 : 1.05,
              children: [
                KpiStatCard(
                  icon: LucideIcons.mapPin,
                  label: 'Toplam İstasyon',
                  value: '${MockData.stations.length}',
                  trendLabel: '+%4.2 bu ay',
                  trend: TrendDirection.up,
                ),
                KpiStatCard(
                  icon: LucideIcons.building,
                  label: 'Aktif Operatör',
                  value: '${MockData.operators.length}',
                  trendLabel: '+2 yeni sözleşme',
                  trend: TrendDirection.up,
                  accent: colors.accentSecondary,
                ),
                KpiStatCard(
                  icon: LucideIcons.users,
                  label: 'Kayıtlı Kullanıcı',
                  value: '86.4K',
                  trendLabel: '+%11 bu ay',
                  trend: TrendDirection.up,
                  accent: colors.info,
                ),
                KpiStatCard(
                  icon: LucideIcons.database,
                  label: 'Veri Sürümü',
                  value: 'v128',
                  trendLabel: '3 gün önce',
                  trend: TrendDirection.flat,
                  accent: colors.warning,
                ),
              ],
            ),
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
