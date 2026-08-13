import 'package:flutter/material.dart';

import '../core/theme/app_radius_extension.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

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
    final muted = context.voltaviaColors.textMuted;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: context.voltaviaColors.surfaceElevated,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: muted),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: AppTextStyles.title, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            message,
            style: AppTextStyles.body.copyWith(color: muted),
            textAlign: TextAlign.center,
          ),
          if (action != null) ...[
            const SizedBox(height: AppSpacing.lg),
            action!,
          ],
        ],
      ),
    );
  }
}
