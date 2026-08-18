import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/connector_type.dart';
import '../../data/models/station.dart';
import '../../widgets/bento_card.dart';
import '../../widgets/gradient_button.dart';
import 'payment_method_screen.dart';

/// Konnektör/soket seçimi — OCPI/API entegrasyonu tamamlandığında
/// gerçek EVSE eşleştirmesiyle değiştirilecek adım (bkz. ROADMAP.md § 2.4).
class StartChargingScreen extends StatefulWidget {
  final Station station;

  const StartChargingScreen({super.key, required this.station});

  @override
  State<StartChargingScreen> createState() => _StartChargingScreenState();
}

class _StartChargingScreenState extends State<StartChargingScreen> {
  ConnectorType? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.station.connectors.first;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    return Scaffold(
      appBar: AppBar(title: const Text('Şarjı Başlat')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.station.name, style: text.headline),
            const SizedBox(height: 4),
            Text(
              '${widget.station.chargeOperator.name} · ${widget.station.district}, ${widget.station.city}',
              style: text.bodyMuted,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Konnektör Seç', style: text.title),
            const SizedBox(height: AppSpacing.sm),
            ...widget.station.connectors.map((c) {
              final selected = c == _selected;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: BentoCard(
                  onTap: () => setState(() => _selected = c),
                  tint: selected ? colors.accentPrimary.withValues(alpha: 0.08) : null,
                  child: Row(
                    children: [
                      Icon(c.icon, color: colors.accentPrimary),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.label, style: text.bodyStrong),
                            Text('${widget.station.maxPowerKw.toStringAsFixed(0)} kW\'a kadar', style: text.captionMuted),
                          ],
                        ),
                      ),
                      Icon(
                        selected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: selected ? colors.accentPrimary : colors.textMuted,
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: AppSpacing.lg),
            BentoCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Icon(LucideIcons.info, size: 17, color: colors.textMuted),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      'Ödeme, operatörün lisanslı ödeme kuruluşu üzerinden alınır. '
                      'Kart bilgilerin Voltavia sunucularında tutulmaz.',
                      style: text.captionMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            GradientButton(
              label: 'Devam Et',
              icon: LucideIcons.arrowRight,
              onPressed: _selected == null
                  ? null
                  : () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => PaymentMethodScreen(station: widget.station)),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
