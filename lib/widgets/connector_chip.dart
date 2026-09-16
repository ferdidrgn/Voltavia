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
      padding: const EdgeInsets.only(left: 4, right: AppSpacing.xs, top: 4, bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        color: colors.surfaceHighlight,
        border: Border.all(color: colors.borderStrong),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [colors.accentPrimary, colors.accentSecondary]),
              shape: BoxShape.circle,
            ),
            child: Icon(type.icon, size: 11, color: Colors.white),
          ),
          const SizedBox(width: 5),
          Text(
            type.label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
