import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../charging/active_charging_screen.dart';
import '../favorites/favorites_screen.dart';
import '../map/map_screen.dart';
import '../profile/profile_screen.dart';
import '../stations/station_list_screen.dart';
import 'home_dashboard_screen.dart';

/// Uygulamanın ana kabuğu: alt gezinme çubuğu (bottom navbar) ve aktif şarj
/// oturumu varsa her sekmenin üstünde beliren canlı durum şeridi.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _destinations = [
    NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Ana Sayfa'),
    NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map), label: 'Harita'),
    NavigationDestination(
      icon: Icon(Icons.ev_station_outlined),
      selectedIcon: Icon(Icons.ev_station),
      label: 'İstasyonlar',
    ),
    NavigationDestination(
      icon: Icon(Icons.favorite_border),
      selectedIcon: Icon(Icons.favorite),
      label: 'Favoriler',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'Profil',
    ),
  ];

  void _goToTab(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final screens = [
      HomeDashboardScreen(onNavigateTab: _goToTab),
      const MapScreen(),
      const StationListScreen(),
      const FavoritesScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (appState.hasActiveSession) _ActiveSessionBanner(appState: appState),
            Expanded(
              child: IndexedStack(index: _index, children: screens),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _goToTab,
        destinations: _destinations,
      ),
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
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ActiveChargingScreen()),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: AppColors.heroGradient),
        ),
        child: Row(
          children: [
            const Icon(Icons.bolt_rounded, color: Colors.white, size: 20),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                '${session.stationName} · şarj oluyor · ${Formatters.duration(elapsed)}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}
