import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_semantic_colors.dart';
import 'app_spacing.dart';

/// Yüzeyler düz ve sessiz tutulur. Gölge ve cam efekti yalnızca yüzen
/// gezinme ve kenar çubuğunda kullanılır; kartlar mikro kenarlıkla durur.
abstract final class AppGlass {
  static BoxDecoration surface(
    BuildContext context, {
    double radius = AppRadius.lg,
    bool elevated = false,
    Color? tint,
    Color? glowColor,
  }) {
    final colors = context.colors;
    final base = tint ?? (elevated ? colors.surfaceHighlight : colors.surface);
    return BoxDecoration(
      color: base,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: colors.borderStrong, width: 1),
      boxShadow: [
        if (glowColor != null)
          BoxShadow(color: glowColor.withValues(alpha: colors.isDark ? 0.16 : 0.1), blurRadius: 18, spreadRadius: -8),
      ],
    );
  }

  static BoxDecoration outline(BuildContext context, {double radius = AppRadius.lg}) {
    final colors = context.colors;
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: colors.border, width: 1),
    );
  }

  const AppGlass._();
}

/// Gerçek arka plan bulanıklığı (`BackdropFilter`) uygulayan cam panel —
/// yalnızca sidebar ve floating bottom nav gibi sabit/yüzen yüzeylerde
/// kullanılır (performans nedeniyle her kartta tekrarlanmaz).
class GlassPanel extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;

  const GlassPanel({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(AppRadius.xl)),
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: colors.isDark ? 0.6 : 0.75),
            borderRadius: borderRadius,
            border: Border.all(color: colors.border, width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}
