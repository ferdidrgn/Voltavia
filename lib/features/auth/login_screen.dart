import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_palette.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../home/home_shell.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscure = true;

  void _continue() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xl),
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: AppPalette.indigoGradient),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(LucideIcons.zap, color: Colors.white, size: 28),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Tekrar hoş geldin', style: text.display),
              const SizedBox(height: AppSpacing.xxs),
              Text('Şarj istasyonlarını bulmaya devam etmek için giriş yap.', style: text.bodyMuted),
              const SizedBox(height: AppSpacing.lg),
              _TestEntryBanner(onTap: _continue),
              const SizedBox(height: AppSpacing.lg),
              const TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'E-posta', prefixIcon: Icon(LucideIcons.mail, size: 18)),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  prefixIcon: const Icon(LucideIcons.lock, size: 18),
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? LucideIcons.eye : LucideIcons.eyeOff, size: 18),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: () {}, child: const Text('Şifremi unuttum')),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: _continue, child: const Text('Giriş Yap')),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(child: Divider(color: colors.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    child: Text('veya', style: text.captionMuted),
                  ),
                  Expanded(child: Divider(color: colors.border)),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _continue,
                  icon: const Icon(Icons.g_mobiledata, size: 26),
                  label: const Text('Google ile devam et'),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _continue,
                  icon: const Icon(Icons.apple),
                  label: const Text('Apple ile devam et'),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Hesabın yok mu?', style: text.bodyMuted),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    ),
                    child: const Text('Kayıt Ol'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

/// UI/UX incelemesi için giriş yapmadan uygulamaya erişim sağlayan kısayol.
/// Yalnızca tasarım/mockup aşamasında kullanılır; gerçek Firebase Authentication
/// bağlandığında bu banner kaldırılmalıdır.
class _TestEntryBanner extends StatelessWidget {
  final VoidCallback onTap;

  const _TestEntryBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    return Material(
      color: colors.accentSecondary.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: colors.accentSecondary, width: 1.2),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.accentSecondary,
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
                child: const Icon(LucideIcons.eye, color: Colors.white, size: 18),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Test Girişi', style: text.bodyStrong),
                    Text('Giriş yapmadan tüm ekranları incele', style: text.captionMuted),
                  ],
                ),
              ),
              Icon(LucideIcons.arrowRight, size: 17, color: colors.accentSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
