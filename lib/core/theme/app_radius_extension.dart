import 'package:flutter/material.dart';

/// Temanın standart paletinde yer almayan ek anlamsal renkleri taşıyan
/// [ThemeExtension]. `Theme.of(context).extension<VoltaviaColors>()!` ile erişilir.
@immutable
class VoltaviaColors extends ThemeExtension<VoltaviaColors> {
  final Color success;
  final Color danger;
  final Color warning;
  final Color fast;
  final Color textMuted;
  final Color surfaceElevated;
  final Color border;

  const VoltaviaColors({
    required this.success,
    required this.danger,
    required this.warning,
    required this.fast,
    required this.textMuted,
    required this.surfaceElevated,
    required this.border,
  });

  @override
  VoltaviaColors copyWith({
    Color? success,
    Color? danger,
    Color? warning,
    Color? fast,
    Color? textMuted,
    Color? surfaceElevated,
    Color? border,
  }) {
    return VoltaviaColors(
      success: success ?? this.success,
      danger: danger ?? this.danger,
      warning: warning ?? this.warning,
      fast: fast ?? this.fast,
      textMuted: textMuted ?? this.textMuted,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      border: border ?? this.border,
    );
  }

  @override
  VoltaviaColors lerp(ThemeExtension<VoltaviaColors>? other, double t) {
    if (other is! VoltaviaColors) return this;
    return VoltaviaColors(
      success: Color.lerp(success, other.success, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      fast: Color.lerp(fast, other.fast, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      border: Color.lerp(border, other.border, t)!,
    );
  }
}

extension VoltaviaColorsX on BuildContext {
  VoltaviaColors get voltaviaColors => Theme.of(this).extension<VoltaviaColors>()!;
}
