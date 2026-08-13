import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius_extension.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/station.dart';
import '../../widgets/connector_chip.dart';
import '../../widgets/map_grid_background.dart';
import '../../widgets/status_badge.dart';
import '../charging/start_charging_screen.dart';

class StationDetailScreen extends StatelessWidget {
  final Station station;

  const StationDetailScreen({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final muted = context.voltaviaColors.textMuted;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 190,
            backgroundColor: context.voltaviaColors.surfaceElevated,
            leading: Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: _CircleButton(icon: Icons.arrow_back, onTap: () => Navigator.of(context).pop()),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xs),
                child: AnimatedBuilder(
                  animation: appState,
                  builder: (context, _) => _CircleButton(
                    icon: appState.isFavorite(station.id) ? Icons.favorite : Icons.favorite_border,
                    iconColor: appState.isFavorite(station.id) ? AppColors.statusBusy : null,
                    onTap: () => appState.toggleFavorite(station.id),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  MapGridBackground(
                    baseColor: isDark ? const Color(0xFF0D1326) : const Color(0xFFE9EDFB),
                    lineColor: isDark ? Colors.white : AppColors.brandPrimary,
                  ),
                  Center(
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.brandPrimary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.brandPrimary.withValues(alpha: 0.5),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.bolt, color: Colors.white, size: 28),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(station.name, style: AppTextStyles.displayMd),
                            const SizedBox(height: 4),
                            Text(
                              '${station.address}, ${station.district}/${station.city}',
                              style: AppTextStyles.body.copyWith(color: muted),
                            ),
                          ],
                        ),
                      ),
                      StatusBadge(status: station.status),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, color: AppColors.statusMaintenance, size: 18),
                      const SizedBox(width: 2),
                      Text(station.rating.toStringAsFixed(1), style: AppTextStyles.bodyStrong),
                      const SizedBox(width: AppSpacing.md),
                      Icon(Icons.place_outlined, size: 16, color: muted),
                      const SizedBox(width: 2),
                      Text(Formatters.km(station.distanceKm), style: TextStyle(color: muted)),
                      const SizedBox(width: AppSpacing.md),
                      Icon(Icons.storefront_outlined, size: 16, color: muted),
                      const SizedBox(width: 2),
                      Text(station.chargeOperator.name, style: TextStyle(color: muted)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: _StatTile(
                          icon: Icons.bolt,
                          label: 'Maks. Güç',
                          value: '${station.maxPowerKw.toStringAsFixed(0)} kW',
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _StatTile(
                          icon: Icons.payments_outlined,
                          label: 'Birim Fiyat',
                          value: '${Formatters.tryPrice(station.pricePerKwh)}/kWh',
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _StatTile(
                          icon: Icons.power_outlined,
                          label: 'Soket',
                          value: '${station.socketCount} adet',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Bağlantı Tipleri', style: AppTextStyles.title),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: station.connectors.map((c) => ConnectorChip(type: c)).toList(),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Operatör Bilgisi', style: AppTextStyles.title),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: context.voltaviaColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: context.voltaviaColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: AppColors.energyGradient),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            station.chargeOperator.logoLetter,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(station.chargeOperator.name, style: AppTextStyles.bodyStrong),
                              Text(
                                station.canStartFromApp
                                    ? 'Voltavia ile uygulama içi şarj mevcut'
                                    : 'Bu operatörle uygulama içi entegrasyon henüz yok',
                                style: AppTextStyles.caption.copyWith(color: muted),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Navigasyon uygulamasına yönlendiriliyor…')),
                    );
                  },
                  icon: const Icon(Icons.navigation_outlined),
                  label: const Text('Navigasyon'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: station.canStartFromApp
                      ? () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => StartChargingScreen(station: station)),
                          )
                      : null,
                  icon: const Icon(Icons.bolt_rounded),
                  label: Text(station.canStartFromApp ? 'Şarjı Başlat' : 'Şu An Uygun Değil'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final muted = context.voltaviaColors.textMuted;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.xs),
      decoration: BoxDecoration(
        color: context.voltaviaColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.voltaviaColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.brandPrimary, size: 20),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.bodyStrong, textAlign: TextAlign.center),
          Text(label, style: AppTextStyles.caption.copyWith(color: muted)),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const _CircleButton({required this.icon, required this.onTap, this.iconColor});

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
          child: Icon(icon, size: 20, color: iconColor),
        ),
      ),
    );
  }
}
