import 'package:flutter/material.dart';

import '../core/theme/app_semantic_colors.dart';
import '../core/theme/app_spacing.dart';
import '../data/models/connector_type.dart';

class StatusBadge extends StatefulWidget {
  final StationStatus status;
  final bool compact;

  const StatusBadge({super.key, required this.status, this.compact = false});

  @override
  State<StatusBadge> createState() => _StatusBadgeState();
}

class _StatusBadgeState extends State<StatusBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _color(BuildContext context) {
    final c = context.colors;
    switch (widget.status) {
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
    final pulsing = widget.status == StationStatus.available;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.compact ? AppSpacing.xs : AppSpacing.sm,
        vertical: widget.compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.32)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pulsing)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.7 * _controller.value),
                      blurRadius: 6 + (4 * _controller.value),
                      spreadRadius: 1 + (1.5 * _controller.value),
                    ),
                  ],
                ),
              ),
            )
          else
            Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            widget.status.label,
            style: TextStyle(
              color: color,
              fontSize: widget.compact ? 11 : 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
