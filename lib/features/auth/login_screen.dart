import 'package:flutter/material.dart';

import '../../core/firebase/account_service.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/plug_mark.dart';
import '../home/home_shell.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscure = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _openCatalog() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeShell()),
      (route) => false,
    );
  }

  Future<void> _signIn() async {
    final message = await AccountService.signIn(_emailController.text, _passwordController.text);
    if (!mounted) return;
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      return;
    }
    _openCatalog();
  }

  Future<void> _reset() async {
    final message = await AccountService.sendReset(_emailController.text);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? 'Sıfırlama bağlantısı gönderildi.')),
    );
  }

  void _providerUnavailable() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google ve Apple girişi Firebase projesi bağlanınca açılır.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xl),
              const PlugMark(size: 72, progress: 0.66, animate: false),
              const SizedBox(height: AppSpacing.lg),
              Text('Tekrar hoş geldin', style: text.display),
              const SizedBox(height: AppSpacing.xxs),
              Text('Şarj istasyonlarını bulmaya devam etmek için giriş yap.', style: text.bodyMuted),
              const SizedBox(height: AppSpacing.lg),
              _TestEntryBanner(onTap: _openCatalog),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'E-posta', prefixIcon: Icon(Icons.mail_rounded, size: 18)),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _passwordController,
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  prefixIcon: const Icon(Icons.lock_rounded, size: 18),
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded, size: 18),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: _reset, child: const Text('Şifremi unuttum')),
              ),
              const SizedBox(height: AppSpacing.sm),
              GradientButton(label: 'Giriş Yap', onPressed: _signIn),
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
                  onPressed: _providerUnavailable,
                  icon: const Icon(Icons.g_mobiledata, size: 26),
                  label: const Text('Google ile devam et'),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _providerUnavailable,
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
        ),
      ),
    );
  }
}

/// Hesap gerekmeden herkese açık istasyon kataloğuna geçer.
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
                child: const Icon(Icons.visibility_rounded, color: Colors.white, size: 18),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kataloğa bak', style: text.bodyStrong),
                    Text('Hesap yok. İstasyon listesi herkese açık.', style: text.captionMuted),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_rounded, size: 17, color: colors.accentSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
