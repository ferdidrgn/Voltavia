import 'package:flutter/material.dart';

/// Voltavia ham renk paleti — "Electric" temasi: enerji/şarj markasına uygun
/// canlı violet-mavi ve volt yeşili aksanlarla zenginleştirilmiş, hafif
/// mor-mavi tonlu (soğuk nötr değil) bir koyu zemin üzerine kurulu. Bu dosya
/// yalnızca ham renk sabitlerini tutar; anlamsal (semantic) eşlemeler için
/// [AppSemanticColors]'a bakın.
abstract final class AppPalette {
  // Koyu tema (bayrak taşıyan / birincil deneyim) — hafif violet-mavi tonlu
  // nötrler, düz gri yerine daha "canlı" bir zemin hissi verir.
  static const Color darkCanvas = Color(0xFF0A0A14);
  static const Color darkSurface = Color(0xFF161522);
  static const Color darkSurfaceHighlight = Color(0xFF201F2E);
  static const Color darkTextPrimary = Color(0xFFF8F7FF);
  static const Color darkTextSecondary = Color(0xFFA6A3BC);
  static const Color darkTextMuted = Color(0xFF6F6C86);

  // Açık tema — aynı dil, aydınlık ve tertemiz yüzeyler.
  static const Color lightCanvas = Color(0xFFFAFAFF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceHighlight = Color(0xFFF1EFFA);
  static const Color lightTextPrimary = Color(0xFF15131F);
  static const Color lightTextSecondary = Color(0xFF5B5875);
  static const Color lightTextMuted = Color(0xFF9C99B4);

  // Aksan renkleri — "Electric" seti: mor-mavi birincil, volt yeşili ikincil.
  static const Color violet = Color(0xFF7C5CFF);
  static const Color violetStrong = Color(0xFF6538FF);
  static const Color violetSoft = Color(0xFF9C85FF);
  static const Color volt = Color(0xFF00E6A8);
  static const Color voltSoft = Color(0xFF5CF2C6);
  static const Color amber = Color(0xFFFFB020);
  static const Color rose = Color(0xFFFF4D6D);
  static const Color sky = Color(0xFF22C7FF);
  static const Color pink = Color(0xFFFF5CA8);

  // Geriye dönük takma adlar (eski isimlendirme, aynı Electric setine işaret eder).
  static const Color indigo = violet;
  static const Color indigoStrong = violetStrong;
  static const Color indigoSoft = violetSoft;
  static const Color emerald = volt;
  static const Color emeraldSoft = voltSoft;

  // Gradyanlar
  static const List<Color> indigoGradient = [Color(0xFF7C5CFF), Color(0xFF4F7CFF)];
  static const List<Color> emeraldGradient = [Color(0xFF00E6A8), Color(0xFF00C2FF)];
  static const List<Color> auroraGradient = [Color(0xFF7C5CFF), Color(0xFF00E6A8)];
  static const List<Color> sunsetGradient = [Color(0xFFFFB020), Color(0xFFFF4D6D)];
  static const List<Color> campaignGradient = [Color(0xFFFF5CA8), Color(0xFF7C5CFF)];
  static const List<Color> voltGradient = [Color(0xFF00E6A8), Color(0xFF00C2FF)];

  // Mikro kenarlık / yüzey opaklık ölçeği
  static const double borderSubtle = 0.10;
  static const double borderMedium = 0.16;
  static const double borderStrong = 0.26;
  static const double glassSurfaceOpacity = 0.55;

  const AppPalette._();
}
