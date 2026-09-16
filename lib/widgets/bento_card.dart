import 'package:flutter/material.dart';

import '../core/theme/app_glass.dart';
import '../core/theme/app_semantic_colors.dart';
import '../core/theme/app_spacing.dart';

/// Bento-grid mimarisinin temel yapı taşı: mikro kenarlıklı, cam yüzeyli,
/// isteğe bağlı olarak masaüstünde imleç üzerine gelindiğinde hafifçe
/// yükselen kart. Tüm Ana Sayfa/Dashboard bölümleri bu kart üzerine kurulur.
class BentoCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final double radius;
  final Color? tint;
  final bool elevated;
  final Color? glowColor;

  const BentoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.onTap,
    this.radius = AppRadius.xl,
    this.tint,
    this.elevated = false,
    this.glowColor,
  });

  @override
  State<BentoCard> createState() => _BentoCardState();
}

class _BentoCardState extends State<BentoCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final hovered = _hovering && widget.onTap != null;
    final decoration = AppGlass.surface(
      context,
      radius: widget.radius,
      elevated: widget.elevated,
      tint: widget.tint,
      glowColor: widget.glowColor,
    ).copyWith(
      border: Border.all(
        color: hovered ? context.colors.accentPrimary.withValues(alpha: 0.5) : context.colors.borderStrong,
        width: 1,
      ),
    );

    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      transform: hovered
          ? (Matrix4.identity()..translateByDouble(0.0, -3.0, 0.0, 1.0))
          : Matrix4.identity(),
      decoration: decoration,
      padding: widget.padding,
      child: widget.child,
    );

    final interactive = widget.onTap == null
        ? content
        : Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(widget.radius),
            child: InkWell(
              borderRadius: BorderRadius.circular(widget.radius),
              onTap: widget.onTap,
              child: content,
            ),
          );

    if (widget.onTap == null) return interactive;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: interactive,
    );
  }
}
