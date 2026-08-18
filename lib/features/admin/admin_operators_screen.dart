import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/responsive.dart';
import '../../data/mock/mock_data.dart';
import 'widgets/admin_data_table.dart';

class AdminOperatorsScreen extends StatelessWidget {
  const AdminOperatorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    final isDesktop = Responsive.isDesktop(context);

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
                if (isDesktop) Text('Operatörler', style: text.display) else Text('Şarj operatörü / firma hesapları', style: text.bodyMuted),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(LucideIcons.plus, size: 16),
                  label: const Text('Yeni Operatör'),
                ),
              ],
            ),
            const Gap(AppSpacing.md),
            AdminDataTable(
              minWidth: isDesktop ? 0 : 640,
              columns: const [
                AdminTableColumn('Operatör', flex: 3),
                AdminTableColumn('İstasyon Sayısı', flex: 2),
                AdminTableColumn('Uygulama İçi Entegrasyon', flex: 2),
                AdminTableColumn('Durum', flex: 2),
              ],
              rows: [
                for (final op in MockData.operators)
                  [
                    Text(op.name, style: text.bodyStrong, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text('${MockData.stationsFor(op.id).length}', style: text.bodyMuted),
                    op.hasAppIntegration
                        ? Icon(LucideIcons.check, size: 16, color: colors.success)
                        : Text('—', style: text.captionMuted),
                    Text(
                      op.hasAppIntegration ? 'Aktif' : 'Görüşme Aşamasında',
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
