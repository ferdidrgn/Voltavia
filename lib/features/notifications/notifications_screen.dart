import 'package:flutter/material.dart';

import '../../core/theme/app_palette.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/responsive.dart';
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

  List<Color> _gradientFor(NotificationKind kind) {
    switch (kind) {
      case NotificationKind.session:
        return AppPalette.indigoGradient;
      case NotificationKind.system:
        return AppPalette.emeraldGradient;
      case NotificationKind.promo:
        return AppPalette.campaignGradient;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifications = MockData.notifications;
    final colors = context.colors;
    final text = context.text;
    final isDesktop = Responsive.isDesktop(context);

    final content = notifications.isEmpty
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
              final gradient = _gradientFor(n.kind);
              return BentoCard(
                tint: n.isRead ? null : colors.accentPrimary.withValues(alpha: 0.06),
                glowColor: n.isRead ? null : gradient.first,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: gradient),
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: gradient.first.withValues(alpha: 0.35), blurRadius: 12, offset: const Offset(0, 4))],
                          ),
                          child: Icon(_iconFor(n.kind), size: 19, color: Colors.white),
                        ),
                        if (!n.isRead)
                          Positioned(
                            top: -1,
                            right: -1,
                            child: Container(
                              width: 11,
                              height: 11,
                              decoration: BoxDecoration(
                                color: colors.danger,
                                shape: BoxShape.circle,
                                border: Border.all(color: colors.surface, width: 2),
                              ),
                            ),
                          ),
                      ],
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
          );

    return Scaffold(
      appBar: AppBar(title: const Text('Bildirimler')),
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
