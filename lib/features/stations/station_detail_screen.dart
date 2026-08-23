import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/station.dart';
import '../../widgets/bento_card.dart';
import '../../widgets/connector_chip.dart';
import '../../widgets/map_grid_background.dart';
import '../../widgets/status_badge.dart';
import '../charging/start_charging_screen.dart';
import '../operators/operator_detail_screen.dart';

class StationDetailScreen extends StatelessWidget {
  final Station station;

  const StationDetailScreen({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final colors = context.colors;
    final text = context.text;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 190,
            backgroundColor: colors.surface,
            leading: Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: _CircleButton(icon: Icons.arrow_back_rounded, onTap: () => Navigator.of(context).pop()),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xs),
                child: AnimatedBuilder(
                  animation: appState,
                  builder: (context, _) => _CircleButton(
                    icon: appState.isFavorite(station.id) ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    iconColor: appState.isFavorite(station.id) ? colors.danger : null,
                    onTap: () => appState.toggleFavorite(station.id),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  MapGridBackground(baseColor: colors.canvas, lineColor: colors.accentPrimary),
                  Center(
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: AppPalette.indigoGradient),
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.canvas, width: 3),
                        boxShadow: [BoxShadow(color: colors.accentPrimary.withValues(alpha: 0.5), blurRadius: 20)],
                      ),
                      child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 26),
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
                            Text(station.name, style: text.display.copyWith(fontSize: 26)),
                            const SizedBox(height: 4),
                            Text(
                              '${station.address}, ${station.district}/${station.city}',
                              style: text.bodyMuted,
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
                      Icon(Icons.star_rounded, color: colors.warning, size: 18),
                      const SizedBox(width: 2),
                      Text(station.rating.toStringAsFixed(1), style: text.bodyStrong),
                      const SizedBox(width: AppSpacing.md),
                      Icon(Icons.place_rounded, size: 15, color: colors.textMuted),
                      const SizedBox(width: 2),
                      Text(Formatters.km(station.distanceKm), style: text.bodyMuted),
                      const SizedBox(width: AppSpacing.md),
                      Icon(Icons.apartment_rounded, size: 15, color: colors.textMuted),
                      const SizedBox(width: 2),
                      Text(station.chargeOperator.name, style: text.bodyMuted),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: _StatTile(
                          icon: Icons.bolt_rounded,
                          label: 'Maks. Güç',
                          value: '${station.maxPowerKw.toStringAsFixed(0)} kW',
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _StatTile(
                          icon: Icons.credit_card_rounded,
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
                  Text('Bağlantı Tipleri', style: text.title),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: station.connectors.map((c) => ConnectorChip(type: c)).toList(),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Operatör Bilgisi', style: text.title),
                  const SizedBox(height: AppSpacing.sm),
                  BentoCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => OperatorDetailScreen(chargeOperator: station.chargeOperator)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: AppPalette.auroraGradient),
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
                              Text(station.chargeOperator.name, style: text.bodyStrong),
                              Text(
                                station.canStartFromApp
                                    ? 'Voltavia ile uygulama içi şarj mevcut'
                                    : 'Bu operatörle uygulama içi entegrasyon henüz yok',
                                style: text.captionMuted,
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded, size: 18, color: colors.textMuted),
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
                  icon: const Icon(Icons.navigation_rounded, size: 17),
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
                  icon: const Icon(Icons.bolt_rounded, size: 17),
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
    final text = context.text;
    return BentoCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.xs),
      child: Column(
        children: [
          Icon(icon, color: context.colors.accentPrimary, size: 20),
          const SizedBox(height: 4),
          Text(value, style: text.bodyStrong, textAlign: TextAlign.center),
          Text(label, style: text.captionMuted),
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
    final colors = context.colors;
    return Material(
      color: colors.surface,
      shape: CircleBorder(side: BorderSide(color: colors.border)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: Icon(icon, size: 19, color: iconColor ?? colors.textSecondary),
        ),
      ),
    );
  }
}
