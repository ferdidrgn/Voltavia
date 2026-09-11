import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/station.dart';
import '../../widgets/bento_card.dart';
import '../../widgets/gradient_button.dart';
import '../profile/add_payment_method_screen.dart';
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
  String? _selectedId;
  bool _processing = false;

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
    final colors = context.colors;
    final text = context.text;
    final appState = AppStateScope.of(context);
    final methods = appState.paymentMethods;
    _selectedId ??= methods.isNotEmpty
        ? methods.firstWhere((m) => m.isDefault, orElse: () => methods.first).id
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Ödeme Yöntemi')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.station.chargeOperator.name} lisanslı ödeme altyapısı', style: text.title),
            const SizedBox(height: 4),
            Text(
              'Tutar, şarj tamamlandığında tüketilen kWh üzerinden operatör tarafından tahsil edilir.',
              style: text.bodyMuted,
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final method in methods)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: BentoCard(
                  onTap: () => setState(() => _selectedId = method.id),
                  tint: method.id == _selectedId ? colors.accentPrimary.withValues(alpha: 0.08) : null,
                  child: Row(
                    children: [
                      Icon(Icons.credit_card_rounded, color: colors.accentPrimary),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text('${method.label} •••• ${method.last4}', style: text.bodyStrong),
                      ),
                      Icon(
                        method.id == _selectedId ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: method.id == _selectedId ? colors.accentPrimary : colors.textMuted,
                      ),
                    ],
                  ),
                ),
              ),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const AddPaymentMethodScreen())),
              icon: const Icon(Icons.add_rounded, size: 17),
              label: const Text('Yeni kart ekle'),
            ),
            const Spacer(),
            Row(
              children: [
                Icon(Icons.lock_rounded, size: 15, color: colors.textMuted),
                const SizedBox(width: 6),
                Expanded(
                  child: Text('Kart numarası ve CVV Voltavia veritabanında saklanmaz.', style: text.captionMuted),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            _processing
                ? const Center(child: CircularProgressIndicator())
                : GradientButton(
                    label: 'Şarjı Başlat',
                    icon: Icons.bolt_rounded,
                    onPressed: _selectedId == null ? null : _confirm,
                  ),
          ],
        ),
      ),
    );
  }
}
