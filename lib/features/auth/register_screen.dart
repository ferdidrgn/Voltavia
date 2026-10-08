import 'package:flutter/material.dart';

import '../../core/firebase/account_service.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/gradient_button.dart';
import '../home/home_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscure = true;
  bool _acceptTerms = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    final message = await AccountService.register(_emailController.text, _passwordController.text);
    if (!mounted) return;
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    return Scaffold(
      appBar: AppBar(title: const Text('Hesap Oluştur')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.sm),
              Text('Voltavia\'ya katıl', style: text.display),
              const SizedBox(height: AppSpacing.xxs),
              Text('Birkaç bilgiyle şarj istasyonlarını keşfetmeye başla.', style: text.bodyMuted),
              const SizedBox(height: AppSpacing.xl),
              const TextField(
                decoration: InputDecoration(labelText: 'Ad Soyad', prefixIcon: Icon(Icons.person_rounded, size: 18)),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'E-posta', prefixIcon: Icon(Icons.mail_rounded, size: 18)),
              ),
              const SizedBox(height: AppSpacing.md),
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
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Checkbox(value: _acceptTerms, onChanged: (v) => setState(() => _acceptTerms = v ?? false)),
                  Expanded(
                    child: Text(
                      'KVKK Aydınlatma Metni ve Kullanım Koşullarını kabul ediyorum.',
                      style: text.captionMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              GradientButton(
                label: 'Hesap Oluştur',
                onPressed: _acceptTerms ? _createAccount : null,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
