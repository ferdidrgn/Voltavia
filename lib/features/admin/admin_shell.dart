import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/initials_avatar.dart';
import '../../widgets/nav_item.dart';
import '../../widgets/responsive_scaffold.dart';
import 'admin_audit_log_screen.dart';
import 'admin_licenses_screen.dart';
import 'admin_login_screen.dart';
import 'admin_operators_screen.dart';
import 'admin_overview_screen.dart';
import 'admin_stations_screen.dart';

/// Voltavia Admin Dashboard'unun adaptive kabuğu — aynı `ResponsiveScaffold`
/// bileşenini tüketici uygulamasıyla paylaşır, yalnızca kendi sekme setiyle.
class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _index = 0;

  static const _items = [
    NavItem(icon: LucideIcons.layoutGrid, activeIcon: LucideIcons.layoutGrid, label: 'Genel Bakış'),
    NavItem(icon: Icons.ev_station_outlined, activeIcon: Icons.ev_station_rounded, label: 'İstasyonlar'),
    NavItem(icon: LucideIcons.building, activeIcon: LucideIcons.building, label: 'Operatörler'),
    NavItem(icon: LucideIcons.creditCard, activeIcon: LucideIcons.creditCard, label: 'Firma/Lisans'),
    NavItem(icon: LucideIcons.shield, activeIcon: LucideIcons.shield, label: 'Audit Log'),
  ];

  void _goToTab(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;

    return ResponsiveScaffold(
      brandLabel: 'Voltavia',
      brandSubLabel: 'Admin Paneli',
      items: _items,
      selectedIndex: _index,
      onSelect: _goToTab,
      pages: const [
        AdminOverviewScreen(),
        AdminStationsScreen(),
        AdminOperatorsScreen(),
        AdminLicensesScreen(),
        AdminAuditLogScreen(),
      ],
      sidebarFooter: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.md),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          onTap: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
            (route) => false,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            child: Row(
              children: [
                const InitialsAvatar(name: 'Admin Voltavia', size: 32),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('admin@voltavia.app', style: text.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text('Çıkış Yap', style: text.captionMuted.copyWith(color: colors.danger)),
                    ],
                  ),
                ),
                Icon(LucideIcons.logOut, size: 16, color: colors.danger),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
