import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/firebase/firebase_gate.dart';
import '../../data/models/app_notification.dart';
import '../../core/theme/responsive.dart';
import '../../widgets/bento_card.dart';
import '../../widgets/kpi_stat_card.dart';
import '../../widgets/section_header.dart';
import '../charging/active_charging_screen.dart';
import '../history/history_screen.dart';
import '../notifications/notifications_screen.dart';
import '../operators/operators_screen.dart';
import '../profile/add_vehicle_screen.dart';
import '../route_planner/widgets/route_planner_banner.dart';
import '../map/station_map.dart';
import '../stations/station_detail_screen.dart';
import 'widgets/nearby_stations_section.dart';
import 'widgets/nearest_charge_stage.dart';
import 'widgets/operators_section.dart';
import 'widgets/quick_actions_grid.dart';

Future<void> _explainAndRequestLocation(BuildContext context) async {
  final accepted = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Yakındaki istasyonlar'),
      content: const Text(
        'Listeyi sana göre sıralamak için konumunu yalnızca bu istekte kullanırız. Arka planda izleme yok.',
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Şimdi değil')),
        TextButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Konumu kullan')),
      ],
    ),
  );
  if (accepted == true && context.mounted) {
    await AppStateScope.of(context).requestDeviceLocation();
  }
}

/// Voltavia'nın Ana Sayfası — bento-grid mimarili gösterge paneli. Kullanıcının
/// en sık ihtiyaç duyduğu tüm akışların (harita, istasyonlar, kampanyalar,
/// firmalar, bildirimler) kısa özetleri tek ekranda bir araya gelir.
class HomeDashboardScreen extends StatelessWidget {
  final ValueChanged<int> onNavigateTab;

  const HomeDashboardScreen({super.key, required this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final colors = context.colors;
    final text = context.text;
    final isDesktop = Responsive.isDesktop(context);
    final unreadCount = appState.unreadNotificationCount;
    final greetingName = appState.displayName.trim();
    final catalog = List.of(appState.stations)..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    final nearest = catalog.take(5).toList();

    final quickActions = [
      QuickActionItem(
        icon: Icons.map_rounded,
        label: 'Harita',
        onTap: () => onNavigateTab(1),
        color: AppPalette.violet,
      ),
      QuickActionItem(
        icon: Icons.ev_station_rounded,
        label: 'İstasyonlar',
        onTap: () => onNavigateTab(2),
        color: AppPalette.volt,
      ),
      QuickActionItem(
        icon: Icons.favorite_rounded,
        label: 'Favoriler',
        onTap: () => onNavigateTab(3),
        color: AppPalette.pink,
      ),
      QuickActionItem(
        icon: Icons.history_rounded,
        label: 'Geçmiş',
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HistoryScreen())),
        color: AppPalette.amber,
      ),
      QuickActionItem(
        icon: Icons.notifications_rounded,
        label: 'Bildirimler',
        onTap: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsScreen())),
        color: AppPalette.sky,
      ),
      QuickActionItem(
        icon: Icons.person_rounded,
        label: 'Profil',
        onTap: () => onNavigateTab(4),
        color: AppPalette.violetSoft,
      ),
    ];

    final content = ListView(
      padding: EdgeInsets.fromLTRB(
        isDesktop ? AppSpacing.xxl : AppSpacing.md,
        AppSpacing.md,
        isDesktop ? AppSpacing.xxl : AppSpacing.md,
        AppSpacing.xxl,
      ),
      children: [
        if (nearest.isNotEmpty)
        NearestChargeStage(
          station: nearest.first,
          onOpen: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => StationDetailScreen(station: nearest.first)),
          ),
          trailing: _NotificationButton(
            unreadCount: unreadCount,
            onTap: () =>
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsScreen())),
          ),
        ).enterFade(),
        const Gap(AppSpacing.md),
        Text(
          greetingName.isEmpty ? 'Bugün nereden şarj alacaksın?' : '$greetingName, bugün nereden şarj alacaksın?',
          style: text.bodyMuted,
        ).enterFade(),
        if (FirebaseGate.maintenance) ...[
          const Gap(AppSpacing.sm),
          Text('Bakım modu açık. Katalog gezilebilir, şarj başlatılmaz.', style: text.captionMuted),
        ],
        const Gap(AppSpacing.md),
        InkWell(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          onTap: () => onNavigateTab(2),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 3),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(color: colors.borderStrong, width: 1.2),
              boxShadow: [
                if (colors.isDark) BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 8)),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.search_rounded, color: colors.accentPrimary, size: 19),
                const Gap(AppSpacing.xs),
                Text('İstasyon, operatör veya şehir ara', style: text.bodyMuted),
              ],
            ),
          ),
        ).enterFade(delay: AppMotion.staggerStep),
        if (appState.hasActiveSession) ...[
          const Gap(AppSpacing.lg),
          _ActiveSessionCard(
            stationName: appState.activeSession!.stationName,
            onTap: () =>
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ActiveChargingScreen())),
          ),
        ],
        const Gap(AppSpacing.lg),
        _HomeKpis(favoriteCount: appState.favoriteStationIds.length).enterRise(delay: AppMotion.staggerStep),
        const Gap(AppSpacing.lg),
        QuickActionsGrid(items: quickActions).enterRise(delay: AppMotion.staggerStep * 3),
        const Gap(AppSpacing.lg),
        const RoutePlannerBanner().enterRise(delay: AppMotion.staggerStep * 3),
        if (appState.vehicles.isEmpty) ...[
          const Gap(AppSpacing.lg),
          BentoCard(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddVehicleScreen())),
            child: Row(
              children: [
                Icon(Icons.directions_car_filled_outlined, color: colors.accentPrimary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Aracını kaydet', style: text.bodyStrong),
                      Text(
                        'Konnektör uyumu, istasyon filtresi ve rota menzili bu kayda bağlanır.',
                        style: text.captionMuted,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        const Gap(AppSpacing.lg),
        SectionHeader(
          title: appState.usingDeviceLocation ? 'Sana En Yakın Noktalar' : 'İstanbul merkezine göre',
          actionLabel: 'Haritada Gör',
          onAction: () => onNavigateTab(1),
        ),
        NearbyStationsSection(
          stations: nearest,
          measuredFromDevice: appState.usingDeviceLocation,
          onOpenMap: () => onNavigateTab(1),
          onRequestLocation: appState.usingDeviceLocation ? null : () => _explainAndRequestLocation(context),
        ),
        const Gap(AppSpacing.lg),
        SectionHeader(
          title: 'Firmalar',
          actionLabel: 'Tümünü Gör',
          onAction: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OperatorsScreen())),
        ),
        const OperatorsSection(),
        const Gap(AppSpacing.lg),
        SectionHeader(
          title: 'Son Bildirimler',
          actionLabel: 'Tümünü Gör',
          onAction: () =>
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsScreen())),
        ),
        if (appState.notifications.isEmpty)
          Text('Bildirim yok.', style: text.captionMuted)
        else
          ...appState.notifications.take(2).map((n) => _NotificationPreview(notification: n)),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(width: 460, child: content),
                const VerticalDivider(width: 1),
                Expanded(
                  child: StationMap(
                    stations: catalog,
                    selected: nearest.isEmpty ? null : nearest.first,
                    onSelect: (station) => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => StationDetailScreen(station: station)),
                    ),
                  ),
                ),
              ],
            )
          : content,
    );
  }

}

class _HomeKpis extends StatelessWidget {
  final int favoriteCount;

  const _HomeKpis({required this.favoriteCount});

  @override
  Widget build(BuildContext context) {
    final cards = [
      const KpiStatCard(icon: Icons.bolt_rounded, label: 'Bu ay şarj', value: '0'),
      const KpiStatCard(
        icon: Icons.electric_bolt_rounded,
        label: 'Toplam kWh',
        value: '0',
        accent: AppPalette.emerald,
      ),
      KpiStatCard(
        icon: Icons.favorite_rounded,
        label: 'Favoriler',
        value: '$favoriteCount',
        accent: AppPalette.sky,
      ),
    ];
    if (Responsive.isMobile(context)) {
      return Column(
        children: [
          for (var i = 0; i < cards.length; i++) ...[
            if (i > 0) const Gap(AppSpacing.sm),
            cards[i],
          ],
        ],
      );
    }
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < cards.length; i++) ...[
            if (i > 0) const Gap(AppSpacing.sm),
            Expanded(child: cards[i]),
          ],
        ],
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onTap;

  const _NotificationButton({required this.unreadCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surface,
      shape: CircleBorder(side: BorderSide(color: colors.border)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(Icons.notifications_rounded, color: colors.textSecondary, size: 20),
              if (unreadCount > 0)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: colors.danger,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.surface, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActiveSessionCard extends StatelessWidget {
  final String stationName;
  final VoidCallback onTap;

  const _ActiveSessionCard({required this.stationName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppPalette.indigoGradient),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), shape: BoxShape.circle),
                child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 19),
              ),
              const Gap(AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Şarj devam ediyor', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    Text(
                      stationName,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationPreview extends StatelessWidget {
  final AppNotification notification;

  const _NotificationPreview({required this.notification});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: BentoCard(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: AppSpacing.sm),
              decoration: BoxDecoration(
                color: notification.isRead ? Colors.transparent : colors.accentPrimary,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.title, style: text.bodyStrong.copyWith(fontSize: 13.5)),
                  Text(
                    notification.message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.captionMuted,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
