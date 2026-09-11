import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/vehicle.dart';
import '../../widgets/bento_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/gradient_button.dart';
import 'add_vehicle_screen.dart';

/// Kullanıcının kayıtlı araçlarını listeler — her araç, istasyon uyumluluğu
/// ve menzil tahmini için konnektör tipi ve batarya kapasitesini taşır.
class VehiclesScreen extends StatelessWidget {
  const VehiclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final text = context.text;

    return Scaffold(
      appBar: AppBar(title: const Text('Araçlarım')),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          final vehicles = appState.vehicles;
          if (vehicles.isEmpty) {
            return Center(
              child: EmptyState(
                icon: Icons.directions_car_filled_outlined,
                title: 'Henüz araç eklemedin',
                message: 'Aracını ekle; uyumlu konnektörlere sahip istasyonları önceliklendirelim.',
                action: SizedBox(
                  width: 200,
                  child: GradientButton(
                    label: 'Araç Ekle',
                    icon: Icons.add_rounded,
                    onPressed: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => const AddVehicleScreen())),
                  ),
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Text(
                'Aracının konnektör tipine göre istasyon önerilerini kişiselleştiriyoruz.',
                style: text.bodyMuted,
              ),
              const SizedBox(height: AppSpacing.md),
              for (final vehicle in vehicles) ...[
                _VehicleCard(vehicle: vehicle),
                const SizedBox(height: AppSpacing.sm),
              ],
              const SizedBox(height: AppSpacing.sm),
              GradientButton(
                label: 'Araç Ekle',
                icon: Icons.add_rounded,
                onPressed: () =>
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddVehicleScreen())),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final Vehicle vehicle;

  const _VehicleCard({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    final appState = AppStateScope.of(context);

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.accentPrimary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(Icons.directions_car_filled_rounded, color: colors.accentPrimary, size: 22),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${vehicle.brand} ${vehicle.model}',
                            style: text.bodyStrong,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (vehicle.isDefault) ...[
                          const SizedBox(width: AppSpacing.xs),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: colors.accentSecondary.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(AppRadius.xs),
                            ),
                            child: Text(
                              'Varsayılan',
                              style: text.captionMuted.copyWith(
                                color: colors.accentSecondary,
                                fontWeight: FontWeight.w700,
                                fontSize: 10.5,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(vehicle.plate, style: text.captionMuted),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert_rounded, color: colors.textMuted, size: 20),
                onSelected: (value) {
                  if (value == 'default') appState.setDefaultVehicle(vehicle.id);
                  if (value == 'delete') appState.removeVehicle(vehicle.id);
                },
                itemBuilder: (context) => [
                  if (!vehicle.isDefault)
                    const PopupMenuItem(value: 'default', child: Text('Varsayılan yap')),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Sil', style: TextStyle(color: colors.danger)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(vehicle.connector.icon, size: 15, color: colors.textMuted),
              const SizedBox(width: 4),
              Text(vehicle.connector.label, style: text.captionMuted),
              const SizedBox(width: AppSpacing.sm),
              Icon(Icons.battery_charging_full_rounded, size: 15, color: colors.textMuted),
              const SizedBox(width: 4),
              Text('${vehicle.batteryCapacityKwh.toStringAsFixed(0)} kWh', style: text.captionMuted),
              const SizedBox(width: AppSpacing.sm),
              Icon(Icons.map_outlined, size: 15, color: colors.textMuted),
              const SizedBox(width: 4),
              Text('~${vehicle.estimatedRangeKm.toStringAsFixed(0)} km menzil', style: text.captionMuted),
            ],
          ),
        ],
      ),
    );
  }
}
