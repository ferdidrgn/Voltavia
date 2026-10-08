import 'package:flutter/material.dart';

/// `null` cihaz dilini izler. Türkçe ve İngilizce çalışma anında seçilebilir.
class LocaleController extends ValueNotifier<Locale?> {
  LocaleController() : super(null);

  void setLocale(Locale? locale) => value = locale;
}

class LocaleControllerScope extends InheritedNotifier<LocaleController> {
  const LocaleControllerScope({
    super.key,
    required LocaleController super.notifier,
    required super.child,
  });

  static LocaleController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LocaleControllerScope>();
    assert(scope != null, 'LocaleControllerScope not found in widget tree');
    return scope!.notifier!;
  }
}
