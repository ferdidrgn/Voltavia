import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius_extension.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../auth/login_screen.dart';

class _OnboardPage {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardPage({required this.icon, required this.title, required this.description});
}

const _pages = [
  _OnboardPage(
    icon: Icons.map_rounded,
    title: 'Tüm istasyonlar tek haritada',
    description:
        'Türkiye\'deki şarj istasyonlarını tek bir uygulamadan keşfet; şehir ve ilçeye göre filtrele.',
  ),
  _OnboardPage(
    icon: Icons.bolt_rounded,
    title: 'Ayrı uygulama indirme',
    description:
        'Anlaşmalı operatörlerde şarjı doğrudan Voltavia üzerinden başlat, farklı uygulamalarla uğraşma.',
  ),
  _OnboardPage(
    icon: Icons.verified_user_rounded,
    title: 'Güvenli ödeme',
    description:
        'Ödeme, operatörün lisanslı altyapısı üzerinden alınır. Kart bilgilerin platformda tutulmaz.',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  void _next() {
    if (_index == _pages.length - 1) {
      _finish();
      return;
    }
    _controller.nextPage(duration: const Duration(milliseconds: 320), curve: Curves.easeOut);
  }

  void _finish() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final muted = context.voltaviaColors.textMuted;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: TextButton(onPressed: _finish, child: const Text('Geç')),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final page = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: AppColors.energyGradient),
                            borderRadius: BorderRadius.circular(AppSpacing.xl),
                          ),
                          child: Icon(page.icon, size: 64, color: Colors.white),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Text(page.title, style: AppTextStyles.displayMd, textAlign: TextAlign.center),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body.copyWith(color: muted),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (i) {
                final active = i == _index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active ? AppColors.brandPrimary : muted.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  child: Text(_index == _pages.length - 1 ? 'Başla' : 'Devam Et'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
