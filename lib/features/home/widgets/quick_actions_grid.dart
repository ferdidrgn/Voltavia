import 'package:flutter/material.dart';

import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class QuickActionItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const QuickActionItem({required this.icon, required this.label, required this.onTap, this.color});
}

/// Ana sayfadaki "uygulama içi kısayollar" bölümü — Harita, İstasyonlar,
/// Favoriler gibi sık kullanılan ekranlara tek dokunuşla erişim sağlar.
class QuickActionsGrid extends StatelessWidget {
  final List<QuickActionItem> items;

  const QuickActionsGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.md,
      children: [
        for (final item in items)
          SizedBox(
            width: 84,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.md),
              onTap: item.onTap,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: (item.color ?? colors.accentPrimary).withValues(alpha: colors.isDark ? 0.16 : 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: (item.color ?? colors.accentPrimary).withValues(alpha: 0.28)),
                    ),
                    child: Icon(item.icon, color: item.color ?? colors.accentPrimary, size: 21),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    item.label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.captionMuted.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
