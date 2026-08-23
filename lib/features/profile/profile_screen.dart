import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/state/theme_controller.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/responsive.dart';
import '../../widgets/initials_avatar.dart';
import '../../widgets/kpi_stat_card.dart';
import '../admin/admin_login_screen.dart';
import '../auth/login_screen.dart';
import '../history/history_screen.dart';
import '../notifications/notifications_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeControllerScope.of(context);
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: isDesktop ? null : AppBar(title: const Text('Profil')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              isDesktop ? AppSpacing.xxl : AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            children: [
              if (isDesktop) ...[
                Text('Profil', style: context.text.display),
                const SizedBox(height: AppSpacing.lg),
              ],
              Row(
                children: [
                  const InitialsAvatar(name: 'Ferdi Durgun', size: 64),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ferdi Durgun', style: context.text.headline),
                        const SizedBox(height: 2),
                        Text('ferdidurgun34@gmail.com', style: context.text.bodyMuted),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                    ),
                    icon: const Icon(Icons.edit_rounded, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    Expanded(child: KpiStatCard(icon: Icons.bolt_rounded, label: 'Bu ay şarj', value: '3')),
                    Gap(AppSpacing.sm),
                    Expanded(
                      child: KpiStatCard(
                        icon: Icons.electric_bolt_rounded,
                        label: 'Toplam kWh',
                        value: '91.5',
                        accent: AppPalette.emerald,
                      ),
                    ),
                    Gap(AppSpacing.sm),
                    Expanded(
                      child: KpiStatCard(
                        icon: Icons.credit_card_rounded,
                        label: 'Harcama',
                        value: '778 ₺',
                        accent: AppPalette.sky,
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
                    onTap: () =>
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HistoryScreen())),
                  ),
                  _ProfileItem(
                    icon: Icons.notifications_rounded,
                    label: 'Bildirimler',
                    onTap: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => const NotificationsScreen())),
                  ),
                  const _ProfileItem(icon: Icons.credit_card_rounded, label: 'Ödeme Yöntemlerim'),
                  const _ProfileItem(icon: Icons.directions_car_filled_outlined, label: 'Araçlarım'),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _ProfileSection(
                title: 'Tercihler',
                items: [
                  ValueListenableBuilder<ThemeMode>(
                    valueListenable: themeController,
                    builder: (context, mode, _) => _ThemeModeSelector(mode: mode, onChanged: themeController.setMode),
                  ),
                  const _ProfileItem(icon: Icons.public_rounded, label: 'Dil · Türkçe'),
                  const _ProfileItem(icon: Icons.shield_rounded, label: 'Gizlilik ve KVKK'),
                  const _ProfileItem(icon: Icons.help_outline_rounded, label: 'Yardım ve Destek'),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _ProfileSection(
                title: 'Firma / Operatör müsün?',
                items: [
                  _ProfileItem(
                    icon: Icons.apartment_rounded,
                    label: 'Firma Paneline Git',
                    subtitle: 'İstasyonlarını ve lisansını yönet',
                    onTap: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => const AdminLoginScreen())),
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
                    foregroundColor: context.colors.danger,
                    side: BorderSide(color: context.colors.danger.withValues(alpha: 0.5)),
                  ),
                  icon: const Icon(Icons.logout_rounded, size: 17),
                  label: const Text('Çıkış Yap'),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
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
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs, left: 4),
          child: Text(title, style: context.text.overline),
        ),
        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) Divider(height: 1, color: colors.border),
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
    final colors = context.colors;
    final text = context.text;
    return InkWell(
      onTap: onTap ??
          () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Yakında eklenecek'))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        child: Row(
          children: [
            Icon(icon, size: 19, color: colors.accentPrimary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: text.body),
                  if (subtitle != null) Text(subtitle!, style: text.captionMuted),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 17, color: colors.textMuted),
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
    final colors = context.colors;
    final text = context.text;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.desktop_windows_rounded, size: 19, color: colors.accentPrimary),
              const SizedBox(width: AppSpacing.sm),
              Text('Görünüm', style: text.body),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.desktop_windows_rounded, size: 15), label: Text('Sistem')),
                ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode_rounded, size: 15), label: Text('Açık')),
                ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode_rounded, size: 15), label: Text('Koyu')),
              ],
              selected: {mode},
              showSelectedIcon: false,
              onSelectionChanged: (selection) => onChanged(selection.first),
              style: SegmentedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                selectedBackgroundColor: colors.accentPrimary,
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
            style: text.captionMuted,
          ),
        ],
      ),
    );
  }
}
