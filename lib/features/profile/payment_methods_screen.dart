import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/saved_payment_method.dart';
import '../../widgets/bento_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/gradient_button.dart';
import 'add_payment_method_screen.dart';

/// Kullanıcının kayıtlı ödeme yöntemlerini listeler. Gerçek kart verisi hiçbir
/// zaman Voltavia sunucularında tutulmaz — bu ekran yalnızca operatörün
/// lisanslı altyapısından dönen marka/son 4 hane bilgisini gösterir.
class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final colors = context.colors;
    final text = context.text;

    return Scaffold(
      appBar: AppBar(title: const Text('Ödeme Yöntemlerim')),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          final methods = appState.paymentMethods;
          if (methods.isEmpty) {
            return Center(
              child: EmptyState(
                icon: Icons.credit_card_off_outlined,
                title: 'Henüz kart eklemedin',
                message: 'Şarj ödemelerini hızlandırmak için bir kart ekle.',
                action: SizedBox(
                  width: 200,
                  child: GradientButton(
                    label: 'Kart Ekle',
                    icon: Icons.add_rounded,
                    onPressed: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => const AddPaymentMethodScreen())),
                  ),
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Row(
                children: [
                  Icon(Icons.lock_rounded, size: 15, color: colors.textMuted),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Kart numarası ve CVV Voltavia veritabanında saklanmaz.',
                      style: text.captionMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              for (final method in methods) ...[
                _PaymentMethodCard(method: method),
                const SizedBox(height: AppSpacing.sm),
              ],
              const SizedBox(height: AppSpacing.sm),
              GradientButton(
                label: 'Kart Ekle',
                icon: Icons.add_rounded,
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const AddPaymentMethodScreen())),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final SavedPaymentMethod method;

  const _PaymentMethodCard({required this.method});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    final appState = AppStateScope.of(context);

    return BentoCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.accentPrimary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(Icons.credit_card_rounded, color: colors.accentPrimary, size: 22),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('${method.label} •••• ${method.last4}', style: text.bodyStrong),
                    if (method.isDefault) ...[
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
                Text('${method.holderName} · SKT ${method.expiry}', style: text.captionMuted),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: colors.textMuted, size: 20),
            onSelected: (value) {
              if (value == 'default') appState.setDefaultPaymentMethod(method.id);
              if (value == 'delete') appState.removePaymentMethod(method.id);
            },
            itemBuilder: (context) => [
              if (!method.isDefault) const PopupMenuItem(value: 'default', child: Text('Varsayılan yap')),
              PopupMenuItem(value: 'delete', child: Text('Sil', style: TextStyle(color: colors.danger))),
            ],
          ),
        ],
      ),
    );
  }
}
