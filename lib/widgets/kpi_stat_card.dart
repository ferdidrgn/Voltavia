import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../core/theme/app_semantic_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import 'bento_card.dart';

enum TrendDirection { up, down, flat }

/// Dashboard'larda kullanılan KPI (temel performans göstergesi) kartı —
/// ikon, değer ve isteğe bağlı bir trend rozeti gösterir.
class KpiStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? trendLabel;
  final TrendDirection trend;
  final Color? accent;

  const KpiStatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.trendLabel,
    this.trend = TrendDirection.flat,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    final accentColor = accent ?? colors.accentPrimary;
    final trendColor = switch (trend) {
      TrendDirection.up => colors.success,
      TrendDirection.down => colors.danger,
      TrendDirection.flat => colors.textMuted,
    };
    final trendIcon = switch (trend) {
      TrendDirection.up => LucideIcons.trendingUp,
      TrendDirection.down => LucideIcons.trendingDown,
      TrendDirection.flat => LucideIcons.minus,
    };

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(value, style: text.numeric),
          const SizedBox(height: 2),
          Text(label, style: text.caption),
          if (trendLabel != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(trendIcon, size: 13, color: trendColor),
                const SizedBox(width: 3),
                Text(
                  trendLabel!,
                  style: text.caption.copyWith(color: trendColor, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
