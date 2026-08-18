import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// `flutter_animate` ile kurulan giriş animasyonlarında tutarlılık için
/// paylaşılan süre/eğri/gecikme sabitleri.
abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 220);
  static const Duration base = Duration(milliseconds: 380);
  static const Duration slow = Duration(milliseconds: 560);

  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;

  static const Duration staggerStep = Duration(milliseconds: 60);

  /// Liste/grid öğeleri için kademeli (staggered) giriş animasyonu — index
  /// arttıkça gecikme artar.
  static Duration staggerDelay(int index, {int cap = 8}) =>
      staggerStep * (index > cap ? cap : index);

  const AppMotion._();
}

/// Ekran girişlerinde kullanılan standart "fade + yukarı kayma" efekti.
extension AppEntranceX on Widget {
  Widget enterFade({Duration? delay, Duration duration = AppMotion.base}) {
    return animate(delay: delay).fadeIn(duration: duration, curve: AppMotion.enter);
  }

  Widget enterRise({Duration? delay, Duration duration = AppMotion.base, double offset = 0.08}) {
    return animate(delay: delay)
        .fadeIn(duration: duration, curve: AppMotion.enter)
        .slideY(begin: offset, end: 0, duration: duration, curve: AppMotion.enter);
  }

  Widget enterScale({Duration? delay, Duration duration = AppMotion.base}) {
    return animate(delay: delay)
        .fadeIn(duration: duration, curve: AppMotion.enter)
        .scale(begin: const Offset(0.94, 0.94), end: const Offset(1, 1), duration: duration, curve: AppMotion.enter);
  }
}
