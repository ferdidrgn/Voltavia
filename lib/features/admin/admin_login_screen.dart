import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import 'admin_shell.dart';

/// Admin paneline giriş kapısı — dokümandaki "Admin Paneli: HTML+CSS+Vanilla JS"
/// kararının Flutter'a taşınmış, tek kod tabanlı (web + mobil) karşılığıdır.
class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;

    return Scaffold(
      backgroundColor: colors.canvas,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: AppPalette.indigoGradient),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(LucideIcons.zap, color: Colors.white, size: 24),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('Voltavia', style: text.title),
                Text('Admin Paneli', style: text.captionMuted),
                const SizedBox(height: AppSpacing.xl),
                Text('Yönetici Girişi', style: text.display.copyWith(fontSize: 26)),
                const SizedBox(height: AppSpacing.xxs),
                Text('İstasyon, operatör ve firma verilerini yönetmek için giriş yap.', style: text.bodyMuted),
                const SizedBox(height: AppSpacing.xl),
                const TextField(
                  decoration: InputDecoration(labelText: 'E-posta', prefixIcon: Icon(LucideIcons.mail, size: 18)),
                ),
                const SizedBox(height: AppSpacing.md),
                const TextField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Şifre', prefixIcon: Icon(LucideIcons.lock, size: 18)),
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const AdminShell()),
                    ),
                    child: const Text('Giriş Yap'),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Bu bir arayüz iskeletidir (mock) — Firebase Authentication bağlanınca gerçek girişe geçilecektir.',
                  style: text.captionMuted,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    ).enterFade();
  }
}
