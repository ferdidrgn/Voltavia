import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius_extension.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/app_notification.dart';
import '../../widgets/empty_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  IconData _iconFor(NotificationKind kind) {
    switch (kind) {
      case NotificationKind.session:
        return Icons.bolt_rounded;
      case NotificationKind.system:
        return Icons.info_outline;
      case NotificationKind.promo:
        return Icons.local_offer_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifications = MockData.notifications;
    final muted = context.voltaviaColors.textMuted;

    return Scaffold(
      appBar: AppBar(title: const Text('Bildirimler')),
      body: notifications.isEmpty
          ? Center(
              child: EmptyState(
                icon: Icons.notifications_none_rounded,
                title: 'Bildirim yok',
                message: 'Şarj ve sistem bildirimleri burada görünecek.',
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, i) {
                final n = notifications[i];
                return Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: n.isRead
                        ? context.voltaviaColors.surfaceElevated
                        : AppColors.brandPrimary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: n.isRead ? context.voltaviaColors.border : AppColors.brandPrimary,
                      width: n.isRead ? 1 : 1.2,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.brandPrimary.withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(_iconFor(n.kind), size: 18, color: AppColors.brandPrimary),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(n.title, style: AppTextStyles.bodyStrong),
                            const SizedBox(height: 2),
                            Text(n.message, style: AppTextStyles.body.copyWith(color: muted)),
                            const SizedBox(height: 4),
                            Text(
                              Formatters.relative(n.time),
                              style: AppTextStyles.caption.copyWith(color: muted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
