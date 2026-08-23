import 'package:flutter/material.dart';

import '../../core/theme/app_palette.dart';
import '../../core/theme/app_semantic_colors.dart';
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
    description: 'Türkiye\'deki şarj istasyonlarını tek bir uygulamadan keşfet; şehir ve ilçeye göre filtrele.',
  ),
  _OnboardPage(
    icon: Icons.bolt_rounded,
    title: 'Ayrı uygulama indirme',
    description: 'Anlaşmalı operatörlerde şarjı doğrudan Voltavia üzerinden başlat, farklı uygulamalarla uğraşma.',
  ),
  _OnboardPage(
    icon: Icons.verified_user_rounded,
    title: 'Güvenli ödeme',
    description: 'Ödeme, operatörün lisanslı altyapısı üzerinden alınır. Kart bilgilerin platformda tutulmaz.',
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
    final colors = context.colors;
    final text = context.text;
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
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 140,
                              height: 140,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: AppPalette.auroraGradient),
                                borderRadius: BorderRadius.circular(AppRadius.xxl),
                                boxShadow: [
                                  BoxShadow(color: colors.accentPrimary.withValues(alpha: 0.3), blurRadius: 30, spreadRadius: 2),
                                ],
                              ),
                              child: Icon(page.icon, size: 60, color: Colors.white),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            Text(page.title, style: text.display.copyWith(fontSize: 26), textAlign: TextAlign.center),
                            const SizedBox(height: AppSpacing.sm),
                            Text(page.description, textAlign: TextAlign.center, style: text.bodyMuted),
                          ],
                        ),
                      ),
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
                    color: active ? colors.accentPrimary : colors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _next,
                      child: Text(_index == _pages.length - 1 ? 'Başla' : 'Devam Et'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
