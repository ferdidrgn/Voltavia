import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_radius_extension.dart';
import '../core/theme/app_spacing.dart';
import '../data/models/connector_type.dart';

class ConnectorChip extends StatelessWidget {
  final ConnectorType type;

  const ConnectorChip({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final border = context.voltaviaColors.border;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(type.icon, size: 14, color: AppColors.brandPrimary),
          const SizedBox(width: 4),
          Text(type.label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
