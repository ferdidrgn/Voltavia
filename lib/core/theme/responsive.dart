import 'package:flutter/material.dart';

import 'app_spacing.dart';

/// Adaptive (Web + Mobil) düzen kararları tek yerden alınır.
abstract final class Responsive {
  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= AppBreakpoints.desktop;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= AppBreakpoints.tablet && width < AppBreakpoints.desktop;
  }

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < AppBreakpoints.tablet;

  /// Bento-grid sütun sayısı: genişlik arttıkça daha fazla sütun.
  static int gridColumns(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1440) return 4;
    if (width >= AppBreakpoints.desktop) return 3;
    if (width >= AppBreakpoints.tablet) return 2;
    return 1;
  }

  /// İçerik alanının maksimum genişliği — çok geniş ekranlarda satırların
  /// aşırı uzamasını engeller.
  static double maxContentWidth(BuildContext context) => 1080;

  const Responsive._();
}

/// [Responsive] için yaygın kullanılan koşullu widget seçici.
class AdaptiveLayout extends StatelessWidget {
  final WidgetBuilder desktop;
  final WidgetBuilder mobile;

  const AdaptiveLayout({super.key, required this.desktop, required this.mobile});

  @override
  Widget build(BuildContext context) {
    return Responsive.isDesktop(context) ? desktop(context) : mobile(context);
  }
}
