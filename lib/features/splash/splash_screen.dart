import 'package:flutter/material.dart';

import '../../core/theme/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_spacing.dart';
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: AppPalette.darkCanvas),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: AppPalette.indigoGradient),
                  borderRadius: BorderRadius.circular(AppRadius.xxl),
                  boxShadow: [
                    BoxShadow(color: AppPalette.indigo.withValues(alpha: 0.4), blurRadius: 36, spreadRadius: 4),
                  ],
                ),
                child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 46),
              ).enterScale(),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Voltavia',
                style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.8),
              ).enterFade(delay: AppMotion.staggerStep * 2),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'Tek uygulama, her şarj istasyonu',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
              ).enterFade(delay: AppMotion.staggerStep * 3),
              const SizedBox(height: AppSpacing.xxl),
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation(AppPalette.indigoSoft),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
