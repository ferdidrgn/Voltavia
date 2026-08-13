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
                builder: (context, mode, _) => _ThemeModeSelector(
                  mode: mode,
                  onChanged: themeController.setMode,
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
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) Divider(height: 1, color: context.voltaviaColors.border),
                items[i],
              ],
            ],
          ),
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

/// Sistem (cihaz teması) / Açık (kendi light temamız) / Koyu (kendi dark
/// temamız) arasında seçim yapılan 3'lü tema anahtarı.
class _ThemeModeSelector extends StatelessWidget {
  final ThemeMode mode;
  final ValueChanged<ThemeMode> onChanged;

  const _ThemeModeSelector({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final muted = context.voltaviaColors.textMuted;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.palette_outlined, size: 20, color: AppColors.brandPrimary),
              const SizedBox(width: AppSpacing.sm),
              Text('Görünüm', style: AppTextStyles.body),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.system,
                  icon: Icon(Icons.smartphone_outlined, size: 16),
                  label: Text('Sistem'),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  icon: Icon(Icons.light_mode_outlined, size: 16),
                  label: Text('Açık'),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  icon: Icon(Icons.dark_mode_outlined, size: 16),
                  label: Text('Koyu'),
                ),
              ],
              selected: {mode},
              showSelectedIcon: false,
              onSelectionChanged: (selection) => onChanged(selection.first),
              style: SegmentedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                selectedBackgroundColor: AppColors.brandPrimary,
                selectedForegroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            mode == ThemeMode.system
                ? 'Telefonunun tema ayarını takip eder.'
                : mode == ThemeMode.light
                    ? 'Voltavia açık tema her zaman kullanılır.'
                    : 'Voltavia koyu tema her zaman kullanılır.',
            style: AppTextStyles.caption.copyWith(color: muted),
          ),
        ],
      ),
    );
  }
}
