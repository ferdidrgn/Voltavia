import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../core/theme/app_motion.dart';
import '../core/theme/app_semantic_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Hata durumu görselleştirmesi — bir veri çekme/işlem hatasında kullanıcıya
/// net bir mesaj ve yeniden deneme eylemi sunar.
class ErrorState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const ErrorState({
    super.key,
    this.title = 'Bir şeyler ters gitti',
    required this.message,
    this.onRetry,
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
              color: colors.danger.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: colors.danger.withValues(alpha: 0.3)),
            ),
            child: Icon(Icons.error_outline_rounded, size: 30, color: colors.danger),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: text.title, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.xxs),
          Text(message, style: text.bodyMuted, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(LucideIcons.refreshCw, size: 16),
              label: const Text('Tekrar Dene'),
            ),
          ],
        ],
      ),
    ).enterFade();
  }
}
