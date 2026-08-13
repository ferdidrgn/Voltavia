import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius_extension.dart';
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
    final muted = context.voltaviaColors.textMuted;
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
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: AppColors.heroGradient),
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                ),
                child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 30),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Tekrar hoş geldin', style: AppTextStyles.displayMd),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'Şarj istasyonlarını bulmaya devam etmek için giriş yap.',
                style: AppTextStyles.body.copyWith(color: muted),
              ),
              const SizedBox(height: AppSpacing.lg),
              _TestEntryBanner(onTap: _continue),
              const SizedBox(height: AppSpacing.lg),
              const TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-posta',
                  prefixIcon: Icon(Icons.mail_outline),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
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
                  Expanded(child: Divider(color: context.voltaviaColors.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    child: Text('veya', style: TextStyle(color: muted, fontSize: 13)),
                  ),
                  Expanded(child: Divider(color: context.voltaviaColors.border)),
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
                  Text('Hesabın yok mu?', style: TextStyle(color: muted)),
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
    return Material(
      color: AppColors.brandSecondary.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.brandSecondary, width: 1.2),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.brandSecondary,
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
                child: const Icon(Icons.visibility_outlined, color: Color(0xFF12162B), size: 20),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Test Girişi', style: AppTextStyles.bodyStrong),
                    Text(
                      'Giriş yapmadan tüm ekranları incele',
                      style: AppTextStyles.caption.copyWith(color: context.voltaviaColors.textMuted),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_rounded, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
