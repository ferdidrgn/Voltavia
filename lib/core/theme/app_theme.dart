import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_semantic_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

/// Voltavia'nın Linear/Vercel standardındaki tasarım sisteminin
/// `ThemeData` montajı. Koyu tema bayrak taşıyan (flagship) deneyimdir;
/// açık tema aynı dilin aydınlık bir karşılığıdır.
abstract final class AppTheme {
  static ThemeData get dark => _build(AppSemanticColors.dark());
  static ThemeData get light => _build(AppSemanticColors.light());

  static ThemeData _build(AppSemanticColors colors) {
    final isDark = colors.isDark;
    final appText = AppTextStyles.build(
      primary: colors.textPrimary,
      secondary: colors.textSecondary,
      muted: colors.textMuted,
    );

    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme(
      isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
    );

    final colorScheme = ColorScheme(
      brightness: colors.brightness,
      primary: colors.accentPrimary,
      onPrimary: Colors.white,
      secondary: colors.accentSecondary,
      onSecondary: Colors.white,
      error: colors.danger,
      onError: Colors.white,
      surface: colors.surface,
      onSurface: colors.textPrimary,
      surfaceContainerHighest: colors.surfaceHighlight,
      outline: colors.border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: colors.brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.canvas,
      canvasColor: colors.canvas,
      dividerColor: colors.border,
      splashFactory: InkSparkle.splashFactory,
      textTheme: baseTextTheme.apply(
        bodyColor: colors.textPrimary,
        displayColor: colors.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.canvas,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: appText.headline,
        iconTheme: IconThemeData(color: colors.textPrimary),
      ),
      iconTheme: IconThemeData(color: colors.textSecondary, size: 20),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: colors.border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.accentPrimary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: colors.surfaceHighlight,
          disabledForegroundColor: colors.textMuted,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.lg),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
          textStyle: appText.bodyStrong.copyWith(color: Colors.white),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.textPrimary,
          side: BorderSide(color: colors.borderStrong, width: 1.2),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.lg),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
          textStyle: appText.bodyStrong,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.accentPrimary,
          textStyle: appText.bodyStrong,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
        hintStyle: appText.body.copyWith(color: colors.textMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colors.accentPrimary, width: 1.6),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceHighlight,
        selectedColor: colors.accentPrimary,
        labelStyle: appText.caption.copyWith(color: colors.textPrimary),
        secondaryLabelStyle: appText.caption.copyWith(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
        side: BorderSide(color: colors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
        ),
        showDragHandle: false,
      ),
      dividerTheme: DividerThemeData(color: colors.border, thickness: 1, space: 1),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: colors.accentPrimary.withValues(alpha: 0.16),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 64,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return appText.caption.copyWith(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? colors.accentPrimary : colors.textMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? colors.accentPrimary : colors.textMuted, size: 22);
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.surfaceHighlight,
        contentTextStyle: appText.body,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          side: BorderSide(color: colors.border),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colors.surfaceHighlight,
          borderRadius: BorderRadius.circular(AppRadius.xs),
          border: Border.all(color: colors.border),
        ),
        textStyle: appText.caption,
      ),
      extensions: [colors, appText],
    );
  }

  const AppTheme._();
}
