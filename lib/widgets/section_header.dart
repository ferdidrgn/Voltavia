import 'package:flutter/material.dart';

import '../core/theme/app_palette.dart';
import '../core/theme/app_semantic_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({super.key, required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: AppPalette.indigoGradient,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(title, style: text.headline),
            ],
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionLabel!,
                    style: text.caption.copyWith(color: colors.accentPrimary, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 2),
                  Icon(Icons.chevron_right_rounded, size: 16, color: colors.accentPrimary),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
