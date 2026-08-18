import 'package:flutter/material.dart';

import '../core/theme/app_semantic_colors.dart';
import '../core/theme/app_spacing.dart';
import '../data/models/connector_type.dart';

class ConnectorChip extends StatelessWidget {
  final ConnectorType type;

  const ConnectorChip({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xs),
        color: colors.surfaceHighlight,
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(type.icon, size: 14, color: colors.accentPrimary),
          const SizedBox(width: 4),
          Text(
            type.label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
