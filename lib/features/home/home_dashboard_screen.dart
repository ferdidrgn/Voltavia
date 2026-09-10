import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/responsive.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/app_notification.dart';
import '../../data/models/campaign.dart';
import '../../widgets/bento_card.dart';
import '../../widgets/initials_avatar.dart';
import '../../widgets/kpi_stat_card.dart';
import '../../widgets/section_header.dart';
import '../charging/active_charging_screen.dart';
import '../history/history_screen.dart';
import '../notifications/notifications_screen.dart';
import '../operators/operators_screen.dart';
import '../route_planner/widgets/route_planner_banner.dart';
import 'widgets/campaign_slider.dart';
import 'widgets/nearby_stations_section.dart';
import 'widgets/operators_section.dart';
import 'widgets/quick_actions_grid.dart';

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
    final unreadCount = MockData.notifications.where((n) => !n.isRead).length;
    final nearest = MockData.nearestStations.take(5).toList();

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
        Row(
          children: [
            const InitialsAvatar(name: 'Ferdi Durgun', size: 46),
            const Gap(AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Merhaba, Ferdi 👋', style: text.title),
                  Text('Bugün nereden şarj alacaksın?', style: text.captionMuted),
                ],
              ),
            ),
            _NotificationButton(
              unreadCount: unreadCount,
              onTap: () =>
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsScreen())),
            ),
          ],
        ).enterFade(),
        const Gap(AppSpacing.lg),
        InkWell(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          onTap: () => onNavigateTab(2),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              children: [
                Icon(Icons.search_rounded, color: colors.textMuted, size: 18),
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
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              Expanded(
                child: KpiStatCard(
                  icon: Icons.bolt_rounded,
                  label: 'Bu ay şarj',
                  value: '3',
                  trendLabel: '+1 geçen aya göre',
                  trend: TrendDirection.up,
                ),
              ),
              Gap(AppSpacing.sm),
              Expanded(
                child: KpiStatCard(
                  icon: Icons.electric_bolt_rounded,
                  label: 'Toplam kWh',
                  value: '91.5',
                  trendLabel: 'stabil',
                  trend: TrendDirection.flat,
                  accent: AppPalette.emerald,
                ),
              ),
              Gap(AppSpacing.sm),
              Expanded(
                child: KpiStatCard(
                  icon: Icons.favorite_rounded,
                  label: 'Favoriler',
                  value: '2',
                  accent: AppPalette.sky,
                ),
              ),
            ],
          ),
        ).enterRise(delay: AppMotion.staggerStep),
        const Gap(AppSpacing.lg),
        CampaignSlider(
          campaigns: MockData.campaigns,
          onTap: (Campaign c) => _handleCampaignTap(context, c),
        ).enterRise(delay: AppMotion.staggerStep * 2),
        const Gap(AppSpacing.lg),
        QuickActionsGrid(items: quickActions).enterRise(delay: AppMotion.staggerStep * 3),
        const Gap(AppSpacing.lg),
        const RoutePlannerBanner().enterRise(delay: AppMotion.staggerStep * 3),
        const Gap(AppSpacing.lg),
        SectionHeader(
          title: 'Sana En Yakın Noktalar',
          actionLabel: 'Haritada Gör',
          onAction: () => onNavigateTab(1),
        ),
        NearbyStationsSection(stations: nearest, onOpenMap: () => onNavigateTab(1)),
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
        ...MockData.notifications.take(2).map((n) => _NotificationPreview(notification: n)),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: isDesktop
          ? Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
                child: content,
              ),
            )
          : content,
    );
  }

  void _handleCampaignTap(BuildContext context, Campaign campaign) {
    if (campaign.id == 'c2') {
      onNavigateTab(2);
      return;
    }
    if (campaign.id == 'c3') {
      onNavigateTab(1);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${campaign.title} — yakında')),
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
