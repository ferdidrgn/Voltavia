import 'package:flutter/material.dart';

import '../../core/state/theme_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius_extension.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/initials_avatar.dart';
import '../auth/login_screen.dart';
import '../history/history_screen.dart';
import '../notifications/notifications_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final muted = context.voltaviaColors.textMuted;
    final themeController = ThemeControllerScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Row(
            children: [
              const InitialsAvatar(name: 'Ferdi Durgun', size: 64),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ferdi Durgun', style: AppTextStyles.headline),
                    const SizedBox(height: 2),
                    Text('ferdidurgun34@gmail.com', style: AppTextStyles.body.copyWith(color: muted)),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                ),
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: AppColors.heroGradient),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt_rounded, color: Colors.white),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bu ay 3 şarj oturumu',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '91.5 kWh · 778,30 ₺ tasarruflu şarj',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _ProfileSection(
            title: 'Hesabım',
            items: [
              _ProfileItem(
                icon: Icons.history_rounded,
                label: 'Şarj Geçmişi',
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const HistoryScreen())),
              ),
              _ProfileItem(
                icon: Icons.notifications_none_rounded,
                label: 'Bildirimler',
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const NotificationsScreen())),
              ),
              const _ProfileItem(icon: Icons.credit_card_outlined, label: 'Ödeme Yöntemlerim'),
              const _ProfileItem(icon: Icons.directions_car_filled_outlined, label: 'Araçlarım'),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _ProfileSection(
            title: 'Tercihler',
            items: [
              ValueListenableBuilder<ThemeMode>(
                valueListenable: themeController,
                builder: (context, mode, _) => _ProfileSwitchItem(
                  icon: Icons.dark_mode_outlined,
                  label: 'Koyu Tema',
                  value: mode == ThemeMode.dark,
                  onChanged: (v) => themeController.setMode(v ? ThemeMode.dark : ThemeMode.light),
                ),
              ),
              const _ProfileItem(icon: Icons.language_outlined, label: 'Dil · Türkçe'),
              const _ProfileItem(icon: Icons.shield_outlined, label: 'Gizlilik ve KVKK'),
              const _ProfileItem(icon: Icons.help_outline_rounded, label: 'Yardım ve Destek'),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _ProfileSection(
            title: 'Firma / Operatör müsün?',
            items: [
              const _ProfileItem(
                icon: Icons.storefront_outlined,
                label: 'Firma Paneline Git',
                subtitle: 'İstasyonlarını ve lisansını yönet',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.statusBusy,
                side: const BorderSide(color: AppColors.statusBusy),
              ),
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Çıkış Yap'),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _ProfileSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs, left: 4),
          child: Text(
            title,
            style: AppTextStyles.overline.copyWith(color: context.voltaviaColors.textMuted),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: context.voltaviaColors.surfaceElevated,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: context.voltaviaColors.border),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;

  const _ProfileItem({required this.icon, required this.label, this.subtitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    final muted = context.voltaviaColors.textMuted;
    return InkWell(
      onTap: onTap ??
          () => ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Yakında eklenecek'))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.brandPrimary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.body),
                  if (subtitle != null)
                    Text(subtitle!, style: AppTextStyles.caption.copyWith(color: muted)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: muted),
          ],
        ),
      ),
    );
  }
}

class _ProfileSwitchItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ProfileSwitchItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xxs),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.brandPrimary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(label, style: AppTextStyles.body)),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
