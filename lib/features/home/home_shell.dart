import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../widgets/nav_item.dart';
import '../../widgets/responsive_scaffold.dart';
import '../charging/active_charging_screen.dart';
import '../favorites/favorites_screen.dart';
import '../map/map_screen.dart';
import '../profile/profile_screen.dart';
import '../stations/station_list_screen.dart';
import 'home_dashboard_screen.dart';

/// Uygulamanın adaptive ana kabuğu: ≥1024px'de sabit sidebar, altında ise
/// havada asılı bottom nav ile 5 sekme arasında geçiş sağlar. Aktif şarj
/// oturumu varsa her sekmenin üstünde canlı bir durum şeridi belirir.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _items = [
    NavItem(icon: Icons.grid_view_rounded, activeIcon: Icons.grid_view_rounded, label: 'Ana Sayfa'),
    NavItem(icon: Icons.map_rounded, activeIcon: Icons.map_rounded, label: 'Harita'),
    NavItem(icon: Icons.ev_station_outlined, activeIcon: Icons.ev_station_rounded, label: 'İstasyonlar'),
    NavItem(icon: Icons.favorite_border_rounded, activeIcon: Icons.favorite_rounded, label: 'Favoriler'),
    NavItem(icon: Icons.person_rounded, activeIcon: Icons.person_rounded, label: 'Profil'),
  ];

  void _goToTab(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final pages = [
      HomeDashboardScreen(onNavigateTab: _goToTab),
      const MapScreen(),
      const StationListScreen(),
      const FavoritesScreen(),
      const ProfileScreen(),
    ];

    return ResponsiveScaffold(
      brandLabel: 'Voltavia',
      brandSubLabel: 'Şarj platformu',
      items: _items,
      selectedIndex: _index,
      onSelect: _goToTab,
      pages: pages,
      topBanner: appState.hasActiveSession ? _ActiveSessionBanner(appState: appState) : null,
    );
  }
}

class _ActiveSessionBanner extends StatelessWidget {
  final AppState appState;

  const _ActiveSessionBanner({required this.appState});

  @override
  Widget build(BuildContext context) {
    final session = appState.activeSession!;
    final elapsed = DateTime.now().difference(session.startedAt);
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ActiveChargingScreen()),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppPalette.indigoGradient),
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: [
              BoxShadow(color: AppPalette.indigo.withValues(alpha: 0.35), blurRadius: 18, offset: const Offset(0, 8)),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.bolt_rounded, color: Colors.white, size: 18),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  '${session.stationName} · şarj oluyor · ${Formatters.duration(elapsed)}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
