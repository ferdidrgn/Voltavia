import 'package:flutter/material.dart';

import 'core/state/app_state.dart';
import 'core/state/theme_controller.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';

void main() {
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

  @override
  void dispose() {
    _appState.dispose();
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      notifier: _appState,
      child: ThemeControllerScope(
        notifier: _themeController,
        child: ValueListenableBuilder<ThemeMode>(
          valueListenable: _themeController,
          builder: (context, mode, _) {
            return MaterialApp(
              title: 'Voltavia',
              debugShowCheckedModeBanner: false,
              themeMode: mode,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              home: const SplashScreen(),
            );
          },
        ),
      ),
    );
  }
}
