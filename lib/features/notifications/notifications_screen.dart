import 'package:flutter/material.dart';

import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/app_notification.dart';
import '../../widgets/bento_card.dart';
import '../../widgets/empty_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  IconData _iconFor(NotificationKind kind) {
    switch (kind) {
      case NotificationKind.session:
        return Icons.bolt_rounded;
      case NotificationKind.system:
        return Icons.info_rounded;
      case NotificationKind.promo:
        return Icons.local_offer_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifications = MockData.notifications;
    final colors = context.colors;
    final text = context.text;

    return Scaffold(
      appBar: AppBar(title: const Text('Bildirimler')),
      body: notifications.isEmpty
          ? Center(
              child: EmptyState(
                icon: Icons.notifications_rounded,
                title: 'Bildirim yok',
                message: 'Şarj ve sistem bildirimleri burada görünecek.',
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: notifications.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, i) {
                final n = notifications[i];
                return BentoCard(
                  tint: n.isRead ? null : colors.accentPrimary.withValues(alpha: 0.06),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: colors.accentPrimary.withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(_iconFor(n.kind), size: 18, color: colors.accentPrimary),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(n.title, style: text.bodyStrong),
                            const SizedBox(height: 2),
                            Text(n.message, style: text.bodyMuted),
                            const SizedBox(height: 4),
                            Text(Formatters.relative(n.time), style: text.captionMuted),
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
