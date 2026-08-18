import 'package:flutter/material.dart';

import 'app_palette.dart';

/// Rol tabanlı (semantic) renkler — açık/koyu tema arasında geçiş yapan
/// tüm bileşenler bu sınıf üzerinden okunur, ham [AppPalette] sabitlerine
/// doğrudan erişmez. `context.colors` ile kullanılır.
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  final Color canvas;
  final Color surface;
  final Color surfaceHighlight;
  final Color border;
  final Color borderStrong;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color accentPrimary;
  final Color accentSecondary;
  final Color success;
  final Color danger;
  final Color warning;
  final Color info;
  final Brightness brightness;

  const AppSemanticColors({
    required this.canvas,
    required this.surface,
    required this.surfaceHighlight,
    required this.border,
    required this.borderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.accentPrimary,
    required this.accentSecondary,
    required this.success,
    required this.danger,
    required this.warning,
    required this.info,
    required this.brightness,
  });

  factory AppSemanticColors.dark() => AppSemanticColors(
        canvas: AppPalette.darkCanvas,
        surface: AppPalette.darkSurface,
        surfaceHighlight: AppPalette.darkSurfaceHighlight,
        border: Colors.white.withValues(alpha: AppPalette.borderSubtle),
        borderStrong: Colors.white.withValues(alpha: AppPalette.borderMedium),
        textPrimary: AppPalette.darkTextPrimary,
        textSecondary: AppPalette.darkTextSecondary,
        textMuted: AppPalette.darkTextMuted,
        accentPrimary: AppPalette.indigo,
        accentSecondary: AppPalette.emerald,
        success: AppPalette.emerald,
        danger: AppPalette.rose,
        warning: AppPalette.amber,
        info: AppPalette.sky,
        brightness: Brightness.dark,
      );

  factory AppSemanticColors.light() => AppSemanticColors(
        canvas: AppPalette.lightCanvas,
        surface: AppPalette.lightSurface,
        surfaceHighlight: AppPalette.lightSurfaceHighlight,
        border: Colors.black.withValues(alpha: 0.06),
        borderStrong: Colors.black.withValues(alpha: 0.1),
        textPrimary: AppPalette.lightTextPrimary,
        textSecondary: AppPalette.lightTextSecondary,
        textMuted: AppPalette.lightTextMuted,
        accentPrimary: AppPalette.indigo,
        accentSecondary: AppPalette.emerald,
        success: AppPalette.emerald,
        danger: AppPalette.rose,
        warning: AppPalette.amber,
        info: AppPalette.sky,
        brightness: Brightness.light,
      );

  bool get isDark => brightness == Brightness.dark;

  @override
  AppSemanticColors copyWith({
    Color? canvas,
    Color? surface,
    Color? surfaceHighlight,
    Color? border,
    Color? borderStrong,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? accentPrimary,
    Color? accentSecondary,
    Color? success,
    Color? danger,
    Color? warning,
    Color? info,
    Brightness? brightness,
  }) {
    return AppSemanticColors(
      canvas: canvas ?? this.canvas,
      surface: surface ?? this.surface,
      surfaceHighlight: surfaceHighlight ?? this.surfaceHighlight,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      accentPrimary: accentPrimary ?? this.accentPrimary,
      accentSecondary: accentSecondary ?? this.accentSecondary,
      success: success ?? this.success,
      danger: danger ?? this.danger,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      brightness: brightness ?? this.brightness,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceHighlight: Color.lerp(surfaceHighlight, other.surfaceHighlight, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      accentPrimary: Color.lerp(accentPrimary, other.accentPrimary, t)!,
      accentSecondary: Color.lerp(accentSecondary, other.accentSecondary, t)!,
      success: Color.lerp(success, other.success, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      brightness: t < 0.5 ? brightness : other.brightness,
    );
  }
}

extension AppSemanticColorsX on BuildContext {
  AppSemanticColors get colors => Theme.of(this).extension<AppSemanticColors>()!;
}
