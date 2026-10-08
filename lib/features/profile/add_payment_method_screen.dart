import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/saved_payment_method.dart';
import '../../widgets/bento_card.dart';
import '../../widgets/gradient_button.dart';

/// Kart numarası istenmez. Kullanıcı, tutarın operatör tarafından tahsil
/// edileceğini bu cihazda onaylar.
class AddPaymentMethodScreen extends StatelessWidget {
  const AddPaymentMethodScreen({super.key});

  void _save(BuildContext context) {
    final appState = AppStateScope.of(context);
    if (appState.paymentMethods.any((method) => method.operatorCheckout)) {
      Navigator.of(context).pop();
      return;
    }
    appState.addPaymentMethod(
      SavedPaymentMethod(
        id: 'pay-${DateTime.now().millisecondsSinceEpoch}',
        brand: CardBrand.troy,
        last4: '',
        holderName: 'Şarj bitince operatör tahsil eder',
        expiry: '',
        operatorCheckout: true,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final colors = context.colors;
    return Scaffold(
      appBar: AppBar(title: const Text('Ödeme onayı')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kart numarası bu uygulamada yazılmaz.', style: text.headline),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Şarj bedelini operatörün kendi ödeme kuruluşu alır. Bu onay yalnızca cihazda durur ve bir tahsilat başlatmaz.',
                    style: text.bodyMuted,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  BentoCard(
                    child: Row(
                      children: [
                        Icon(Icons.account_balance_rounded, color: colors.accentPrimary),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'CVV, kart numarası ve son kullanma tarihi istenmez.',
                            style: text.body,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  GradientButton(
                    label: 'Operatör tahsilatını onayla',
                    icon: Icons.check_rounded,
                    onPressed: () => _save(context),
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
