import 'package:flutter/material.dart';

import '../core/theme/app_semantic_colors.dart';
import '../core/theme/app_spacing.dart';
import '../data/models/connector_type.dart';

class StatusBadge extends StatelessWidget {
  final StationStatus status;
  final bool compact;

  const StatusBadge({super.key, required this.status, this.compact = false});

  Color _color(BuildContext context) {
    final c = context.colors;
    switch (status) {
      case StationStatus.available:
        return c.success;
      case StationStatus.busy:
        return c.danger;
      case StationStatus.offline:
        return c.textMuted;
      case StationStatus.maintenance:
        return c.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.xs : AppSpacing.sm,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            status.label,
            style: TextStyle(
              color: color,
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
