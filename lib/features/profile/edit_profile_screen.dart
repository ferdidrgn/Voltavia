import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/initials_avatar.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profili Düzenle'),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profil güncellendi (mock)')),
              );
              Navigator.of(context).pop();
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  const InitialsAvatar(name: 'Ferdi Durgun', size: 88),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: colors.accentPrimary,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.canvas, width: 2),
                      ),
                      child: const Icon(LucideIcons.camera, color: Colors.white, size: 15),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Ad Soyad', style: text.overline),
            const SizedBox(height: AppSpacing.xxs),
            const TextField(decoration: InputDecoration(hintText: 'Ferdi Durgun')),
            const SizedBox(height: AppSpacing.md),
            Text('E-posta', style: text.overline),
            const SizedBox(height: AppSpacing.xxs),
            const TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(hintText: 'ferdidurgun34@gmail.com'),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Telefon', style: text.overline),
            const SizedBox(height: AppSpacing.xxs),
            const TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(hintText: '+90 5xx xxx xx xx'),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Araç Modeli', style: text.overline),
            const SizedBox(height: AppSpacing.xxs),
            const TextField(decoration: InputDecoration(hintText: 'Örn. Tesla Model 3')),
          ],
        ),
      ),
    );
  }
}
