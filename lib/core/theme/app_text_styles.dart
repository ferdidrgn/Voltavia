import 'package:flutter/material.dart';

/// Voltavia tipografi ölçeği. Sistem fontu (Roboto/SF) üzerine kurulu;
/// hiyerarşi ağırlık + harf aralığı ile sağlanır.
abstract final class AppTextStyles {
  static const TextStyle displayLg = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w800,
    height: 1.15,
    letterSpacing: -0.5,
  );

  static const TextStyle displayMd = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    height: 1.2,
    letterSpacing: -0.3,
  );

  static const TextStyle headline = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static const TextStyle title = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  static const TextStyle bodyStrong = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0.8,
  );

  static const TextStyle numeric = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w800,
    height: 1.0,
    letterSpacing: -1,
  );

  const AppTextStyles._();
}
