import 'package:flutter/material.dart';

import '../../core/theme/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/harbor_atmosphere.dart';
import '../../widgets/plug_mark.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppPalette.night,
      body: Stack(
        fit: StackFit.expand,
        children: [
          HarborAtmosphere(forceDark: true),
          _SplashMark(),
        ],
      ),
    );
  }
}

class _SplashMark extends StatelessWidget {
  const _SplashMark();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PlugMark(size: 148, progress: 0.72).enterScale(),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Voltavia',
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.2,
            ),
          ).enterFade(delay: AppMotion.staggerStep * 2),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Tek uygulama, her şarj istasyonu',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.72), fontSize: 15),
          ).enterFade(delay: AppMotion.staggerStep * 3),
        ],
      ),
    );
  }
}
