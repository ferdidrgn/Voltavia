import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius_extension.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/connector_type.dart';
import '../../data/models/station.dart';
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
    final muted = context.voltaviaColors.textMuted;
    return Scaffold(
      appBar: AppBar(title: const Text('Şarjı Başlat')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.station.name, style: AppTextStyles.headline),
            const SizedBox(height: 4),
            Text(
              '${widget.station.chargeOperator.name} · ${widget.station.district}, ${widget.station.city}',
              style: AppTextStyles.body.copyWith(color: muted),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Konnektör Seç', style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.sm),
            ...widget.station.connectors.map((c) {
              final selected = c == _selected;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  onTap: () => setState(() => _selected = c),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.brandPrimary.withValues(alpha: 0.1)
                          : context.voltaviaColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: selected ? AppColors.brandPrimary : context.voltaviaColors.border,
                        width: selected ? 1.6 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(c.icon, color: AppColors.brandPrimary),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.label, style: AppTextStyles.bodyStrong),
                              Text(
                                '${widget.station.maxPowerKw.toStringAsFixed(0)} kW\'a kadar',
                                style: AppTextStyles.caption.copyWith(color: muted),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          selected ? Icons.radio_button_checked : Icons.radio_button_off,
                          color: selected ? AppColors.brandPrimary : muted,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: context.voltaviaColors.surfaceElevated,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: context.voltaviaColors.border),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 18, color: muted),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      'Ödeme, operatörün lisanslı ödeme kuruluşu üzerinden alınır. '
                      'Kart bilgilerin Voltavia sunucularında tutulmaz.',
                      style: AppTextStyles.caption.copyWith(color: muted),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            GradientButton(
              label: 'Devam Et',
              icon: Icons.arrow_forward_rounded,
              onPressed: _selected == null
                  ? null
                  : () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PaymentMethodScreen(station: widget.station),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
