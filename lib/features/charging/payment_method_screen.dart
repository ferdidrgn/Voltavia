import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius_extension.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/station.dart';
import '../../widgets/gradient_button.dart';
import 'active_charging_screen.dart';

/// Operatörün hosted/tokenized ödeme akışını temsil eden mock ekran.
/// Gerçek entegrasyonda bu ekran operatörün ödeme SDK'sına/WebView'ine
/// devredilir; kart verisi Voltavia sunucularından geçmez.
class PaymentMethodScreen extends StatefulWidget {
  final Station station;

  const PaymentMethodScreen({super.key, required this.station});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int _selected = 0;
  bool _processing = false;

  final _methods = const [
    ('Visa •••• 4242', Icons.credit_card),
    ('Mastercard •••• 8891', Icons.credit_card),
  ];

  Future<void> _confirm() async {
    setState(() => _processing = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    final appState = AppStateScope.of(context);
    appState.startSession(widget.station);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const ActiveChargingScreen()),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final muted = context.voltaviaColors.textMuted;
    return Scaffold(
      appBar: AppBar(title: const Text('Ödeme Yöntemi')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.station.chargeOperator.name} lisanslı ödeme altyapısı',
              style: AppTextStyles.title,
            ),
            const SizedBox(height: 4),
            Text(
              'Tutar, şarj tamamlandığında tüketilen kWh üzerinden operatör tarafından tahsil edilir.',
              style: AppTextStyles.body.copyWith(color: muted),
            ),
            const SizedBox(height: AppSpacing.lg),
            ...List.generate(_methods.length, (i) {
              final selected = i == _selected;
              final (label, icon) = _methods[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  onTap: () => setState(() => _selected = i),
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
                        Icon(icon, color: AppColors.brandPrimary),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(child: Text(label, style: AppTextStyles.bodyStrong)),
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
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Yeni kart ekle'),
            ),
            const Spacer(),
            Row(
              children: [
                Icon(Icons.lock_outline, size: 16, color: muted),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Kart numarası ve CVV Voltavia veritabanında saklanmaz.',
                    style: AppTextStyles.caption.copyWith(color: muted),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            _processing
                ? const Center(child: CircularProgressIndicator())
                : GradientButton(
                    label: 'Şarjı Başlat',
                    icon: Icons.bolt_rounded,
                    onPressed: _confirm,
                  ),
          ],
        ),
      ),
    );
  }
}
