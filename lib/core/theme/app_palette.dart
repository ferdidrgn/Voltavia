import 'package:flutter/material.dart';

/// Voltavia "Liman Akımı" paleti.
///
/// Gece otoyolu ve kıyı feribotlarından gelir: derin deniz mürekkebi,
/// sodyum lamba sarısı ve oksitlenmiş bakır yeşili. Mor gradyan ve
/// eşit bento kartı estetiğinin yerine soket yüzü + kablo eğrisi motifi
/// kullanılır. Eski isimler (indigo, violet, volt) yeni değerlere
/// bağlanır; böylece mevcut ekranlar tek seferde yeni dile geçer.
abstract final class AppPalette {
  static const Color night = Color(0xFF07141C);
  static const Color harbor = Color(0xFF102833);
  static const Color tide = Color(0xFF173444);
  static const Color foam = Color(0xFFE4EEF2);
  static const Color porcelain = Color(0xFFF7FBFC);
  static const Color mist = Color(0xFFD5E3E9);
  static const Color ink = Color(0xFF0C1C24);

  static const Color sodium = Color(0xFFE7A317);
  static const Color sodiumSoft = Color(0xFFF3D48A);
  static const Color sea = Color(0xFF127A86);
  static const Color seaDeep = Color(0xFF0C3D4A);
  static const Color seaGlass = Color(0xFF7DCEC4);
  static const Color copper = Color(0xFFC46A3A);
  static const Color coral = Color(0xFFE25B4A);
  static const Color current = Color(0xFF3E8EDE);

  static const Color darkCanvas = night;
  static const Color darkSurface = harbor;
  static const Color darkSurfaceHighlight = tide;
  static const Color darkTextPrimary = Color(0xFFF3F7F8);
  static const Color darkTextSecondary = Color(0xFFA9C0C8);
  static const Color darkTextMuted = Color(0xFF6E8791);

  static const Color lightCanvas = foam;
  static const Color lightSurface = porcelain;
  static const Color lightSurfaceHighlight = mist;
  static const Color lightTextPrimary = ink;
  static const Color lightTextSecondary = Color(0xFF3E5964);
  static const Color lightTextMuted = Color(0xFF7A94A0);

  static const Color violet = sea;
  static const Color violetStrong = seaDeep;
  static const Color violetSoft = seaGlass;
  static const Color indigo = sea;
  static const Color indigoStrong = seaDeep;
  static const Color indigoSoft = seaGlass;
  static const Color volt = Color(0xFF1FA38A);
  static const Color voltSoft = seaGlass;
  static const Color emerald = volt;
  static const Color emeraldSoft = seaGlass;
  static const Color amber = sodium;
  static const Color rose = coral;
  static const Color sky = current;
  static const Color pink = copper;

  static const List<Color> indigoGradient = [seaDeep, sea];
  static const List<Color> emeraldGradient = [Color(0xFF0E6E66), Color(0xFF1FA38A)];
  static const List<Color> auroraGradient = [seaDeep, seaGlass];
  static const List<Color> sunsetGradient = [copper, sodium];
  static const List<Color> campaignGradient = [Color(0xFF123044), Color(0xFF1A6A62)];
  static const List<Color> voltGradient = [seaDeep, seaGlass];
  static const List<Color> lampGradient = [sodium, sodiumSoft];

  static const double borderSubtle = 0.10;
  static const double borderMedium = 0.18;
  static const double borderStrong = 0.28;
  static const double glassSurfaceOpacity = 0.72;

  const AppPalette._();
}
