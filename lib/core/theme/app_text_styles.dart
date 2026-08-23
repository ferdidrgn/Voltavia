import 'package:flutter/material.dart';

/// Projeye gömülü Plus Jakarta Sans font ailesinin adı (bkz. pubspec.yaml
/// `flutter.fonts`). Çalışma zamanında ağdan indirme yapılmaz.
const String kPlusJakartaSans = 'PlusJakartaSans';

/// Plus Jakarta Sans tabanlı, önceden renklendirilmiş metin hiyerarşisi.
/// `context.text` ile kullanılır — her ekranda tekrar tekrar renk parametresi
/// geçmeyi önler ve açık/koyu tema arasında tutarlılığı garanti eder.
@immutable
class AppTextStyles extends ThemeExtension<AppTextStyles> {
  final TextStyle display;
  final TextStyle headline;
  final TextStyle title;
  final TextStyle body;
  final TextStyle bodyMuted;
  final TextStyle bodyStrong;
  final TextStyle caption;
  final TextStyle captionMuted;
  final TextStyle overline;
  final TextStyle numeric;
  final TextStyle numericLg;

  const AppTextStyles({
    required this.display,
    required this.headline,
    required this.title,
    required this.body,
    required this.bodyMuted,
    required this.bodyStrong,
    required this.caption,
    required this.captionMuted,
    required this.overline,
    required this.numeric,
    required this.numericLg,
  });

  factory AppTextStyles.build({
    required Color primary,
    required Color secondary,
    required Color muted,
  }) {
    TextStyle f(double size, FontWeight weight, Color color, {double? spacing, double? height}) {
      return TextStyle(
        fontFamily: kPlusJakartaSans,
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: spacing,
        height: height,
      );
    }

    return AppTextStyles(
      display: f(34, FontWeight.w800, primary, spacing: -0.8, height: 1.15),
      headline: f(22, FontWeight.w700, primary, spacing: -0.3, height: 1.25),
      title: f(16.5, FontWeight.w600, primary, height: 1.3),
      body: f(14.5, FontWeight.w400, primary, height: 1.5),
      bodyMuted: f(14.5, FontWeight.w400, secondary, height: 1.5),
      bodyStrong: f(14.5, FontWeight.w600, primary, height: 1.4),
      caption: f(12.5, FontWeight.w500, secondary, height: 1.3),
      captionMuted: f(12.5, FontWeight.w500, muted, height: 1.3),
      overline: f(11, FontWeight.w700, muted, spacing: 1.0, height: 1.2),
      numeric: f(28, FontWeight.w800, primary, spacing: -0.6, height: 1.0),
      numericLg: f(38, FontWeight.w800, primary, spacing: -1.0, height: 1.0),
    );
  }

  @override
  AppTextStyles copyWith({
    TextStyle? display,
    TextStyle? headline,
    TextStyle? title,
    TextStyle? body,
    TextStyle? bodyMuted,
    TextStyle? bodyStrong,
    TextStyle? caption,
    TextStyle? captionMuted,
    TextStyle? overline,
    TextStyle? numeric,
    TextStyle? numericLg,
  }) {
    return AppTextStyles(
      display: display ?? this.display,
      headline: headline ?? this.headline,
      title: title ?? this.title,
      body: body ?? this.body,
      bodyMuted: bodyMuted ?? this.bodyMuted,
      bodyStrong: bodyStrong ?? this.bodyStrong,
      caption: caption ?? this.caption,
      captionMuted: captionMuted ?? this.captionMuted,
      overline: overline ?? this.overline,
      numeric: numeric ?? this.numeric,
      numericLg: numericLg ?? this.numericLg,
    );
  }

  @override
  AppTextStyles lerp(ThemeExtension<AppTextStyles>? other, double t) {
    if (other is! AppTextStyles) return this;
    return AppTextStyles(
      display: TextStyle.lerp(display, other.display, t)!,
      headline: TextStyle.lerp(headline, other.headline, t)!,
      title: TextStyle.lerp(title, other.title, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      bodyMuted: TextStyle.lerp(bodyMuted, other.bodyMuted, t)!,
      bodyStrong: TextStyle.lerp(bodyStrong, other.bodyStrong, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      captionMuted: TextStyle.lerp(captionMuted, other.captionMuted, t)!,
      overline: TextStyle.lerp(overline, other.overline, t)!,
      numeric: TextStyle.lerp(numeric, other.numeric, t)!,
      numericLg: TextStyle.lerp(numericLg, other.numericLg, t)!,
    );
  }
}

extension AppTextStylesX on BuildContext {
  AppTextStyles get text => Theme.of(this).extension<AppTextStyles>()!;
}
