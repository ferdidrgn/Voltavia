import 'package:flutter/material.dart';

/// Uygulama genelinde açık/koyu tema tercihini tutan basit denetleyici.
/// Varsayılan olarak koyu tema (bayrak taşıyan / flagship deneyim) açılır;
/// kullanıcı Profil → Görünüm'den Sistem veya Açık temaya geçebilir.
class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController() : super(ThemeMode.dark);

  /// Android duvar kağıdı rengini marka vurgusuyla karıştırır. Varsayılan kapalı.
  bool usePlatformAccent = false;

  void toggle() {
    value = value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  void setMode(ThemeMode mode) => value = mode;

  void setPlatformAccent(bool enabled) {
    if (usePlatformAccent == enabled) return;
    usePlatformAccent = enabled;
    notifyListeners();
  }
}

class ThemeControllerScope extends InheritedNotifier<ThemeController> {
  const ThemeControllerScope({
    super.key,
    required ThemeController super.notifier,
    required super.child,
  });

  static ThemeController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeControllerScope>();
    assert(scope != null, 'ThemeControllerScope not found in widget tree');
    return scope!.notifier!;
  }
}
