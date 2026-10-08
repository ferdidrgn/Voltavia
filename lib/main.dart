import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/injector.dart';
import 'core/firebase/firebase_gate.dart';
import 'core/state/app_state.dart';
import 'core/state/locale_controller.dart';
import 'core/state/theme_controller.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';
import 'l10n/app_localizations.dart';
import 'widgets/harbor_atmosphere.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupInjector();
  await FirebaseGate.start();
  runApp(const VoltaviaApp());
}

class VoltaviaApp extends StatefulWidget {
  const VoltaviaApp({super.key});

  @override
  State<VoltaviaApp> createState() => _VoltaviaAppState();
}

class _VoltaviaAppState extends State<VoltaviaApp> {
  final _appState = AppState();
  final _themeController = ThemeController();
  final _localeController = LocaleController();

  @override
  void initState() {
    super.initState();
    _appState.restoreFavorites();
    _appState.restoreProfile();
  }

  @override
  void dispose() {
    _appState.dispose();
    _themeController.dispose();
    _localeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      notifier: _appState,
      child: ThemeControllerScope(
        notifier: _themeController,
        child: LocaleControllerScope(
          notifier: _localeController,
          child: DynamicColorBuilder(
            builder: (lightDynamic, darkDynamic) {
              return ValueListenableBuilder<ThemeMode>(
                valueListenable: _themeController,
                builder: (context, mode, _) {
                  final blend = _themeController.usePlatformAccent;
                  return ValueListenableBuilder<Locale?>(
                    valueListenable: _localeController,
                    builder: (context, locale, _) {
                      return MaterialApp(
                        title: 'Voltavia',
                        debugShowCheckedModeBanner: false,
                        locale: locale,
                        localizationsDelegates: const [
                          AppLocalizations.delegate,
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                          GlobalCupertinoLocalizations.delegate,
                        ],
                        supportedLocales: AppLocalizations.supportedLocales,
                        themeMode: mode,
                        theme: AppTheme.light(platformAccent: blend ? lightDynamic?.primary : null),
                        darkTheme: AppTheme.dark(platformAccent: blend ? darkDynamic?.primary : null),
                        builder: (context, child) => HarborFrame(child: child ?? const SizedBox.shrink()),
                        home: const SplashScreen(),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
