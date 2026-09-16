import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/responsive.dart';
import '../../core/utils/formatters.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/company_license.dart';
import 'widgets/admin_data_table.dart';

class AdminLicensesScreen extends StatelessWidget {
  const AdminLicensesScreen({super.key});

  Color _statusColor(BuildContext context, LicenseStatus status) {
    final colors = context.colors;
    return switch (status) {
      LicenseStatus.active => colors.success,
      LicenseStatus.negotiating => colors.warning,
      LicenseStatus.expired => colors.danger,
    };
  }

  String _statusLabel(LicenseStatus status) {
    return switch (status) {
      LicenseStatus.active => 'Aktif',
      LicenseStatus.negotiating => 'Görüşme',
      LicenseStatus.expired => 'Süresi Doldu',
    };
  }

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final isDesktop = Responsive.isDesktop(context);
    final licenses = MockData.companyLicenses;
    final activeRevenue = licenses
        .where((l) => l.status == LicenseStatus.active)
        .fold<double>(0, (sum, l) => sum + l.monthlyFeeTry);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: isDesktop ? null : AppBar(title: const Text('Firma / Lisans')),
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
            if (isDesktop) Text('Firma / Lisans Yönetimi', style: text.display),
            Text(
              'Sabit lisans/entegrasyon geliri — ROADMAP.md § 3 kapsamı. '
              'Aktif aylık gelir: ${Formatters.tryPrice(activeRevenue)}',
              style: text.bodyMuted,
            ),
            const Gap(AppSpacing.md),
            AdminDataTable(
              minWidth: isDesktop ? 0 : 680,
              columns: const [
                AdminTableColumn('Firma', flex: 3),
                AdminTableColumn('Paket', flex: 2),
                AdminTableColumn('Aylık Bedel', flex: 2),
                AdminTableColumn('Yenileme', flex: 2),
                AdminTableColumn('Durum', flex: 2),
              ],
              rows: [
                for (final l in licenses)
                  [
                    Text(l.companyName, style: text.bodyStrong, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(l.plan, style: text.bodyMuted),
                    Text(
                      l.monthlyFeeTry == 0 ? '—' : Formatters.tryPrice(l.monthlyFeeTry),
                      style: text.bodyMuted,
                    ),
                    Text(Formatters.date(l.renewalDate), style: text.bodyMuted),
                    Text(
                      _statusLabel(l.status),
                      style: text.caption.copyWith(color: _statusColor(context, l.status), fontWeight: FontWeight.w700),
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
