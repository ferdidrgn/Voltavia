import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/responsive.dart';
import '../../data/models/operator.dart';
import 'widgets/admin_data_table.dart';

class AdminOperatorsScreen extends StatefulWidget {
  const AdminOperatorsScreen({super.key});

  @override
  State<AdminOperatorsScreen> createState() => _AdminOperatorsScreenState();
}

class _AdminOperatorsScreenState extends State<AdminOperatorsScreen> {
  static const _rowLimit = 80;

  String _query = '';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    final isDesktop = Responsive.isDesktop(context);
    final appState = AppStateScope.of(context);
    final query = _query.trim().toLowerCase();
    final visible = <({ChargeOperator operator, int stationCount})>[];
    var matchCount = 0;
    for (final entry in appState.operatorCatalog) {
      if (query.isNotEmpty && !entry.operator.name.toLowerCase().contains(query)) continue;
      matchCount++;
      if (visible.length < _rowLimit) visible.add(entry);
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: isDesktop ? null : AppBar(title: const Text('Operatörler')),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isDesktop)
                  Text('Operatörler', style: text.display)
                else
                  Text('Şarj operatörü / firma hesapları', style: text.bodyMuted),
                ElevatedButton.icon(
                  onPressed: () => _showCatalogPending(context),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Yeni Operatör'),
                ),
              ],
            ),
            const Gap(AppSpacing.md),
            if (appState.stationsLoading) ...[
              Text('Katalog yükleniyor', style: text.captionMuted),
              const Gap(AppSpacing.sm),
            ],
            TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: const InputDecoration(
                hintText: 'Operatör ara',
                prefixIcon: Icon(Icons.search_rounded, size: 18),
              ),
            ),
            const Gap(AppSpacing.sm),
            Text('$matchCount operatörden ${visible.length} gösteriliyor', style: text.captionMuted),
            const Gap(AppSpacing.sm),
            if (visible.isEmpty)
              Text('Eşleşen operatör yok.', style: text.bodyMuted)
            else
              AdminDataTable(
                minWidth: isDesktop ? 0 : 640,
                columns: const [
                  AdminTableColumn('Operatör', flex: 3),
                  AdminTableColumn('İstasyon Sayısı', flex: 2),
                  AdminTableColumn('Uygulama İçi Entegrasyon', flex: 2),
                  AdminTableColumn('Durum', flex: 2),
                ],
                rows: [
                  for (final entry in visible)
                    [
                      Text(entry.operator.name, style: text.bodyStrong, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text('${entry.stationCount}', style: text.bodyMuted),
                      entry.operator.hasAppIntegration
                          ? Icon(Icons.check_rounded, size: 16, color: colors.success)
                          : Text('—', style: text.captionMuted),
                      Text(
                        entry.operator.hasAppIntegration ? 'Aktif' : 'Entegrasyon yok',
                        style: text.bodyMuted,
                      ),
                    ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}

void _showCatalogPending(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Katalog düzenlemeleri yönetici arka ucunu bekliyor.')),
  );
}
