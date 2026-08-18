import 'package:flutter/material.dart';

/// Voltavia ham renk paleti — Slate/Zinc tabanlı derin bir SaaS estetiği
/// (Linear/Vercel vitrin standardı). Bu dosya yalnızca ham renk sabitlerini
/// tutar; anlamsal (semantic) eşlemeler için [AppSemanticColors]'a bakın.
abstract final class AppPalette {
  // Zinc nötrleri — Koyu tema (bayrak taşıyan / birincil deneyim)
  static const Color darkCanvas = Color(0xFF09090B);
  static const Color darkSurface = Color(0xFF18181B);
  static const Color darkSurfaceHighlight = Color(0xFF27272A);
  static const Color darkTextPrimary = Color(0xFFFAFAFA);
  static const Color darkTextSecondary = Color(0xFFA1A1AA);
  static const Color darkTextMuted = Color(0xFF71717A);

  // Zinc nötrleri — Açık tema (aynı dil, aydınlık yüzeyler)
  static const Color lightCanvas = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceHighlight = Color(0xFFF4F4F5);
  static const Color lightTextPrimary = Color(0xFF18181B);
  static const Color lightTextSecondary = Color(0xFF52525B);
  static const Color lightTextMuted = Color(0xFFA1A1AA);

  // Aksan renkleri
  static const Color indigo = Color(0xFF6366F1);
  static const Color indigoStrong = Color(0xFF4F46E5);
  static const Color indigoSoft = Color(0xFF8B5CF6);
  static const Color emerald = Color(0xFF10B981);
  static const Color emeraldSoft = Color(0xFF34D399);
  static const Color amber = Color(0xFFF59E0B);
  static const Color rose = Color(0xFFEF4444);
  static const Color sky = Color(0xFF0EA5E9);

  // Gradyanlar
  static const List<Color> indigoGradient = [Color(0xFF6366F1), Color(0xFF8B5CF6)];
  static const List<Color> emeraldGradient = [Color(0xFF10B981), Color(0xFF34D399)];
  static const List<Color> auroraGradient = [Color(0xFF6366F1), Color(0xFF10B981)];
  static const List<Color> sunsetGradient = [Color(0xFFF59E0B), Color(0xFFEF4444)];

  // Mikro kenarlık / yüzey opaklık ölçeği
  static const double borderSubtle = 0.08;
  static const double borderMedium = 0.14;
  static const double borderStrong = 0.24;
  static const double glassSurfaceOpacity = 0.55;

  const AppPalette._();
}
