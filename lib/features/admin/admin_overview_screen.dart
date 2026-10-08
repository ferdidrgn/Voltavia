import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/responsive.dart';
import '../../widgets/kpi_stat_card.dart';
import '../../widgets/status_badge.dart';
import 'widgets/admin_data_table.dart';

class AdminOverviewScreen extends StatelessWidget {
  final VoidCallback? onOpenStations;

  const AdminOverviewScreen({super.key, this.onOpenStations});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    final isDesktop = Responsive.isDesktop(context);
    final appState = AppStateScope.of(context);
    final recentStations = appState.stations.take(8).toList();
    final stationNote = appState.stationsLoading
        ? 'Yükleniyor'
        : appState.stations.isEmpty
            ? 'Katalog boş'
            : 'Canlı katalog';

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
            if (appState.stationsLoading) ...[
              Text('Katalog yükleniyor', style: text.captionMuted),
              const Gap(AppSpacing.sm),
            ],
            _OverviewKpiGrid(
              colors: colors,
              stationCount: appState.stations.length,
              operatorCount: appState.operatorCatalog.length,
              stationNote: stationNote,
            ),
            const Gap(AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Katalogdan ilk kayıtlar', style: text.title),
                TextButton(onPressed: onOpenStations, child: const Text('Tümünü Gör')),
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
                    Text(station.city, style: text.bodyMuted, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(station.chargeOperator.name, style: text.bodyMuted, maxLines: 1, overflow: TextOverflow.ellipsis),
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

/// İstasyon ve operatör sayıları katalogdan gelir. Kullanıcı büyümesi gibi
/// ölçülmeyen rakamlar burada yer almaz.
class _OverviewKpiGrid extends StatelessWidget {
  final AppSemanticColors colors;
  final int stationCount;
  final int operatorCount;
  final String stationNote;

  const _OverviewKpiGrid({
    required this.colors,
    required this.stationCount,
    required this.operatorCount,
    required this.stationNote,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: KpiStatCard(
              icon: Icons.place_rounded,
              label: 'Toplam İstasyon',
              value: '$stationCount',
              trendLabel: stationNote,
              trend: TrendDirection.flat,
            ),
          ),
          const Gap(AppSpacing.sm),
          Expanded(
            child: KpiStatCard(
              icon: Icons.apartment_rounded,
              label: 'Operatör',
              value: '$operatorCount',
              accent: colors.accentSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
