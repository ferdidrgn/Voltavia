import 'package:flutter/material.dart';

/// Voltavia marka renk paleti.
///
/// Marka rengi olarak "Voltaic Indigo" (elektrik/teknoloji hissi) ve
/// vurgu rengi olarak "Volt Lime" (şarj/enerji hissi) kullanılır.
/// Durum renkleri (müsait/dolu/arızalı) marka renginden bilerek ayrıştırılmıştır
/// ki istasyon durumu her zaman net okunsun.
abstract final class AppColors {
  // Marka
  static const Color brandPrimary = Color(0xFF4C5FFF);
  static const Color brandPrimaryDark = Color(0xFF3546D6);
  static const Color brandSecondary = Color(0xFFC6FF6B);

  // Nötr - Koyu tema
  static const Color darkBackground = Color(0xFF0A0E1A);
  static const Color darkSurface = Color(0xFF121729);
  static const Color darkSurfaceElevated = Color(0xFF1A2138);
  static const Color darkBorder = Color(0xFF262E48);
  static const Color darkTextPrimary = Color(0xFFF4F6FF);
  static const Color darkTextSecondary = Color(0xFF9AA3C7);
  static const Color darkTextMuted = Color(0xFF6B7394);

  // Nötr - Açık tema
  static const Color lightBackground = Color(0xFFF5F6FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE3E6F3);
  static const Color lightTextPrimary = Color(0xFF12162B);
  static const Color lightTextSecondary = Color(0xFF565F82);
  static const Color lightTextMuted = Color(0xFF8891B3);

  // Durum renkleri (istasyon müsaitlik / bağlantı tipi rozetleri)
  static const Color statusAvailable = Color(0xFF2ECC71);
  static const Color statusBusy = Color(0xFFEF4444);
  static const Color statusOffline = Color(0xFF8891B3);
  static const Color statusMaintenance = Color(0xFFF5A623);
  static const Color statusFast = Color(0xFF4C5FFF);

  // Gradients
  static const List<Color> heroGradient = [Color(0xFF4C5FFF), Color(0xFF7C3AED)];
  static const List<Color> energyGradient = [Color(0xFF4C5FFF), Color(0xFFC6FF6B)];

  const AppColors._();
}
