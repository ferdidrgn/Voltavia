import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock/city_distances.dart';
import '../../widgets/bento_card.dart';
import '../../widgets/gradient_button.dart';
import '../profile/add_vehicle_screen.dart';
import 'route_result_screen.dart';

/// Şehirler arası uzun yolculuklar için şarj molası öneren rota planlayıcı.
/// Gerçek bir yönlendirme (routing) motoru bağlanana kadar, referans şehir
/// mesafe tablosu ve kullanıcının aracının menzili üzerinden çalışır.
class RoutePlannerScreen extends StatefulWidget {
  const RoutePlannerScreen({super.key});

  @override
  State<RoutePlannerScreen> createState() => _RoutePlannerScreenState();
}

class _RoutePlannerScreenState extends State<RoutePlannerScreen> {
  String _from = CityDistances.cities.first;
  String _to = CityDistances.cities[1];

  void _swap() {
    setState(() {
      final tmp = _from;
      _from = _to;
      _to = tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final colors = context.colors;
    final text = context.text;
    final vehicle = appState.defaultVehicle;

    return Scaffold(
      appBar: AppBar(title: const Text('Rota Planlayıcı')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Şehirler arası yolculuğunda kaç şarj molası gerektiğini ve '
                    'yol üzerindeki uyumlu istasyonları hesaplayalım.',
                    style: text.bodyMuted,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (vehicle == null)
                    BentoCard(
                      child: Row(
                        children: [
                          Icon(Icons.directions_car_filled_outlined, color: colors.warning),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Önce bir araç ekle', style: text.bodyStrong),
                                Text(
                                  'Menzil ve mola sayısı hesaplaması için araç bilgisi gerekli.',
                                  style: text.captionMuted,
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) => const AddVehicleScreen())),
                            child: const Text('Ekle'),
                          ),
                        ],
                      ),
                    )
                  else
                    BentoCard(
                      child: Row(
                        children: [
                          Icon(Icons.directions_car_filled_rounded, color: colors.accentPrimary),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              '${vehicle.brand} ${vehicle.model} · ~${vehicle.estimatedRangeKm.toStringAsFixed(0)} km menzil',
                              style: text.bodyStrong,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: AppSpacing.lg),
                  BentoCard(
                    child: Column(
                      children: [
                        _CityRow(
                          icon: Icons.trip_origin_rounded,
                          label: 'Nereden',
                          value: _from,
                          onChanged: (v) => setState(() => _from = v),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                          child: Row(
                            children: [
                              Expanded(child: Divider(color: colors.border)),
                              IconButton(
                                onPressed: _swap,
                                icon: Icon(Icons.swap_vert_rounded, color: colors.accentPrimary),
                                tooltip: 'Yer değiştir',
                              ),
                              Expanded(child: Divider(color: colors.border)),
                            ],
                          ),
                        ),
                        _CityRow(
                          icon: Icons.place_rounded,
                          label: 'Nereye',
                          value: _to,
                          onChanged: (v) => setState(() => _to = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    '${CityDistances.distanceKm(_from, _to)} km · yaklaşık ${(CityDistances.distanceKm(_from, _to) / 90).toStringAsFixed(1)} sa sürüş',
                    style: text.captionMuted,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  GradientButton(
                    label: 'Rota Oluştur',
                    icon: Icons.route_rounded,
                    onPressed: (_from == _to || vehicle == null)
                        ? null
                        : () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => RouteResultScreen(from: _from, to: _to, vehicle: vehicle),
                              ),
                            ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CityRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  const _CityRow({required this.icon, required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    return Row(
      children: [
        Icon(icon, color: colors.accentPrimary, size: 20),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: text.captionMuted),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  isExpanded: true,
                  style: text.bodyStrong,
                  onChanged: (v) {
                    if (v != null) onChanged(v);
                  },
                  items: [
                    for (final city in CityDistances.cities)
                      DropdownMenuItem(value: city, child: Text(city)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
