import 'package:flutter/material.dart';

import '../core/theme/app_motion.dart';
import '../core/theme/app_semantic_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Boş durum (empty state) görselleştirmesi — liste/veri olmadığında
/// kullanıcıya net bir açıklama ve isteğe bağlı bir eylem sunar.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: colors.surfaceHighlight,
              shape: BoxShape.circle,
              border: Border.all(color: colors.border),
            ),
            child: Icon(icon, size: 32, color: colors.textMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: text.title, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.xxs),
          Text(message, style: text.bodyMuted, textAlign: TextAlign.center),
          if (action != null) ...[
            const SizedBox(height: AppSpacing.lg),
            action!,
          ],
        ],
      ),
    ).enterFade();
  }
}
