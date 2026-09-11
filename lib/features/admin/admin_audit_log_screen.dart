import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/responsive.dart';
import '../../core/utils/formatters.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/bento_card.dart';
import '../../widgets/empty_state.dart';

class AdminAuditLogScreen extends StatelessWidget {
  const AdminAuditLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    final isDesktop = Responsive.isDesktop(context);
    final logs = MockData.auditLog;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: isDesktop ? null : AppBar(title: const Text('Audit Log')),
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
            if (isDesktop) Text('Audit Log', style: text.display),
            Text('Admin/firma panelindeki kritik değişiklik kayıtları', style: text.bodyMuted),
            const Gap(AppSpacing.lg),
            if (logs.isEmpty)
              Center(
                child: EmptyState(
                  icon: Icons.shield_rounded,
                  title: 'Kayıt yok',
                  message: 'Kritik değişiklikler burada listelenecek.',
                ),
              )
            else
              ...logs.map((log) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: BentoCard(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: colors.accentPrimary.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.shield_rounded, size: 15, color: colors.accentPrimary),
                          ),
                          const Gap(AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(log.action, style: text.bodyStrong),
                                const SizedBox(height: 2),
                                Text('${log.actorEmail} · ${Formatters.relative(log.time)}', style: text.captionMuted),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
