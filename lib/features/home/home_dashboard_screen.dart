import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius_extension.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/app_notification.dart';
import '../../data/models/campaign.dart';
import '../../widgets/initials_avatar.dart';
import '../../widgets/section_header.dart';
import '../charging/active_charging_screen.dart';
import '../history/history_screen.dart';
import '../notifications/notifications_screen.dart';
import '../operators/operators_screen.dart';
import 'widgets/campaign_slider.dart';
import 'widgets/nearby_stations_section.dart';
import 'widgets/operators_section.dart';
import 'widgets/quick_actions_grid.dart';

/// Voltavia'nın yeni ana sayfası: kullanıcının en sık ihtiyaç duyduğu tüm
/// akışların (harita, istasyonlar, kampanyalar, firmalar, bildirimler) kısa
/// özetlerle bir araya toplandığı gösterge paneli (dashboard).
class HomeDashboardScreen extends StatelessWidget {
  final ValueChanged<int> onNavigateTab;

  const HomeDashboardScreen({super.key, required this.onNavigateTab});

  Future<void> _refresh() => Future.delayed(const Duration(milliseconds: 700));

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final muted = context.voltaviaColors.textMuted;
    final unreadCount = MockData.notifications.where((n) => !n.isRead).length;
    final nearest = MockData.nearestStations.take(5).toList();

    final quickActions = [
      QuickActionItem(icon: Icons.map_rounded, label: 'Harita', onTap: () => onNavigateTab(1)),
      QuickActionItem(
        icon: Icons.ev_station_rounded,
        label: 'İstasyonlar',
        onTap: () => onNavigateTab(2),
      ),
      QuickActionItem(icon: Icons.favorite_rounded, label: 'Favoriler', onTap: () => onNavigateTab(3)),
      QuickActionItem(
        icon: Icons.history_rounded,
        label: 'Geçmiş',
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HistoryScreen())),
      ),
      QuickActionItem(
        icon: Icons.notifications_rounded,
        label: 'Bildirimler',
        onTap: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsScreen())),
      ),
      QuickActionItem(icon: Icons.person_rounded, label: 'Profil', onTap: () => onNavigateTab(4)),
    ];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xl),
            children: [
              Row(
                children: [
                  const InitialsAvatar(name: 'Ferdi Durgun', size: 44),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Merhaba, Ferdi 👋', style: AppTextStyles.title),
                        Text(
                          'Bugün nereden şarj alacaksın?',
                          style: AppTextStyles.caption.copyWith(color: muted),
                        ),
                      ],
                    ),
                  ),
                  _NotificationButton(
                    unreadCount: unreadCount,
                    onTap: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => const NotificationsScreen())),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              InkWell(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                onTap: () => onNavigateTab(2),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
                  decoration: BoxDecoration(
                    color: context.voltaviaColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: context.voltaviaColors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: muted, size: 20),
                      const SizedBox(width: AppSpacing.xs),
                      Text('İstasyon, operatör veya şehir ara', style: TextStyle(color: muted, fontSize: 14)),
                    ],
                  ),
                ),
              ),
              if (appState.hasActiveSession) ...[
                const SizedBox(height: AppSpacing.lg),
                _ActiveSessionCard(
                  stationName: appState.activeSession!.stationName,
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => const ActiveChargingScreen())),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              CampaignSlider(
                campaigns: MockData.campaigns,
                onTap: (Campaign c) => _handleCampaignTap(context, c),
              ),
              const SizedBox(height: AppSpacing.lg),
              QuickActionsGrid(items: quickActions),
              const SizedBox(height: AppSpacing.lg),
              SectionHeader(
                title: 'Sana En Yakın Noktalar',
                actionLabel: 'Haritada Gör',
                onAction: () => onNavigateTab(1),
              ),
              NearbyStationsSection(stations: nearest, onOpenMap: () => onNavigateTab(1)),
              const SizedBox(height: AppSpacing.lg),
              SectionHeader(
                title: 'Firmalar',
                actionLabel: 'Tümünü Gör',
                onAction: () =>
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OperatorsScreen())),
              ),
              const OperatorsSection(),
              const SizedBox(height: AppSpacing.lg),
              SectionHeader(
                title: 'Son Bildirimler',
                actionLabel: 'Tümünü Gör',
                onAction: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const NotificationsScreen())),
              ),
              ...MockData.notifications.take(2).map((n) => _NotificationPreview(notification: n)),
            ],
          ),
        ),
      ),
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
    return Material(
      color: context.voltaviaColors.surfaceElevated,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(Icons.notifications_outlined, color: context.voltaviaColors.textMuted),
              if (unreadCount > 0)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: AppColors.statusBusy,
                      shape: BoxShape.circle,
                      border: Border.all(color: context.voltaviaColors.surfaceElevated, width: 1.5),
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
            gradient: const LinearGradient(colors: AppColors.heroGradient),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.bolt_rounded, color: Colors.white),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Şarj devam ediyor',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
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
    final muted = context.voltaviaColors.textMuted;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: context.voltaviaColors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: context.voltaviaColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: AppSpacing.sm),
              decoration: BoxDecoration(
                color: notification.isRead ? Colors.transparent : AppColors.brandPrimary,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.title, style: AppTextStyles.bodyStrong.copyWith(fontSize: 13.5)),
                  Text(
                    notification.message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(color: muted),
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
