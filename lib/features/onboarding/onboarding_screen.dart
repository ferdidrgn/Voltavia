import 'dart:ui';

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
  final List<Color> gradient;

  const _OnboardPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
  });
}

const _pages = [
  _OnboardPage(
    icon: Icons.map_rounded,
    title: 'Tüm istasyonlar tek haritada',
    description: 'Türkiye\'deki şarj istasyonlarını tek bir uygulamadan keşfet; şehir ve ilçeye göre filtrele.',
    gradient: AppPalette.indigoGradient,
  ),
  _OnboardPage(
    icon: Icons.bolt_rounded,
    title: 'Ayrı uygulama indirme',
    description: 'Anlaşmalı operatörlerde şarjı doğrudan Voltavia üzerinden başlat, farklı uygulamalarla uğraşma.',
    gradient: AppPalette.voltGradient,
  ),
  _OnboardPage(
    icon: Icons.verified_user_rounded,
    title: 'Güvenli ödeme',
    description: 'Ödeme, operatörün lisanslı altyapısı üzerinden alınır. Kart bilgilerin platformda tutulmaz.',
    gradient: AppPalette.campaignGradient,
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
    final page = _pages[_index];

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: colors.canvas),
          AnimatedContainer(
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.55),
                radius: 0.9,
                colors: [
                  page.gradient.first.withValues(alpha: colors.isDark ? 0.38 : 0.22),
                  colors.canvas.withValues(alpha: 0),
                ],
              ),
            ),
          ),
          SafeArea(
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
                      final p = _pages[i];
                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 440),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _OnboardIcon(page: p),
                                const SizedBox(height: AppSpacing.xxl),
                                Text(
                                  p.title,
                                  style: text.display.copyWith(fontSize: 28),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(p.description, textAlign: TextAlign.center, style: text.bodyMuted),
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
                      width: active ? 26 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: active ? LinearGradient(colors: _pages[i].gradient) : null,
                        color: active ? null : colors.border,
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
                        height: 54,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: page.gradient),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            boxShadow: [
                              BoxShadow(
                                color: page.gradient.first.withValues(alpha: 0.4),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              onTap: _next,
                              child: Center(
                                child: Text(
                                  _index == _pages.length - 1 ? 'Başla' : 'Devam Et',
                                  style: text.bodyStrong.copyWith(color: Colors.white, fontSize: 15.5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardIcon extends StatelessWidget {
  final _OnboardPage page;

  const _OnboardIcon({required this.page});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 128,
      height: 128,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: colors.isDark ? 0.6 : 0.85),
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        border: Border.all(color: colors.borderStrong, width: 1.4),
        boxShadow: [
          BoxShadow(color: page.gradient.first.withValues(alpha: 0.35), blurRadius: 40, spreadRadius: 4),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xxl - 1.4),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [page.gradient.first.withValues(alpha: 0.22), page.gradient.last.withValues(alpha: 0.1)],
              ),
            ),
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(colors: page.gradient).createShader(bounds),
              child: Icon(page.icon, size: 56, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
