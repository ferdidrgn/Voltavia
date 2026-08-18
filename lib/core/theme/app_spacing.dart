/// Tutarlı boşluk (spacing) ölçeği — 4pt grid.
abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;

  const AppSpacing._();
}

/// Bento-grid / SaaS vitrin estetiğine uygun, cömert köşe yarıçapları.
abstract final class AppRadius {
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double pill = 999;

  const AppRadius._();
}

/// Masaüstü/mobil kırılım noktası. 1024px ve üzeri "Web/Desktop" (sidebar +
/// çok sütunlu bento grid) düzeni; altı "Mobile" (floating bottom nav) düzeni.
abstract final class AppBreakpoints {
  static const double desktop = 1024;
  static const double tablet = 720;

  const AppBreakpoints._();
}
