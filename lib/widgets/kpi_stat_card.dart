import 'package:flutter/material.dart';

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
      TrendDirection.up => Icons.trending_up_rounded,
      TrendDirection.down => Icons.trending_down_rounded,
      TrendDirection.flat => Icons.remove_rounded,
    };

    return BentoCard(
      glowColor: accentColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [accentColor, Color.lerp(accentColor, Colors.black, 0.25)!],
              ),
              borderRadius: BorderRadius.circular(AppRadius.md),
              boxShadow: [BoxShadow(color: accentColor.withValues(alpha: 0.4), blurRadius: 14, offset: const Offset(0, 6))],
            ),
            child: Icon(icon, color: Colors.white, size: 21),
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
