import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/saved_payment_method.dart';
import '../../widgets/gradient_button.dart';

/// Kart ekleme formu — mock akış. Gerçek entegrasyonda bu ekran operatörün
/// hosted/tokenized ödeme SDK'sına devredilir; kart verisi Voltavia
/// sunucularından hiçbir zaman geçmez.
class AddPaymentMethodScreen extends StatefulWidget {
  const AddPaymentMethodScreen({super.key});

  @override
  State<AddPaymentMethodScreen> createState() => _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  CardBrand _brand = CardBrand.visa;

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final digits = _numberController.text.replaceAll(RegExp(r'\D'), '');
    final appState = AppStateScope.of(context);
    appState.addPaymentMethod(
      SavedPaymentMethod(
        id: 'pm-${DateTime.now().millisecondsSinceEpoch}',
        brand: _brand,
        last4: digits.length >= 4 ? digits.substring(digits.length - 4) : digits.padLeft(4, '0'),
        holderName: _nameController.text.trim(),
        expiry: _expiryController.text.trim(),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    return Scaffold(
      appBar: AppBar(title: const Text('Kart Ekle')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kart Markası', style: text.bodyStrong),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      children: [
                        for (final b in CardBrand.values)
                          ChoiceChip(
                            label: Text(switch (b) {
                              CardBrand.visa => 'Visa',
                              CardBrand.mastercard => 'Mastercard',
                              CardBrand.troy => 'Troy',
                            }),
                            selected: _brand == b,
                            onSelected: (_) => setState(() => _brand = b),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Kart Üzerindeki İsim',
                        prefixIcon: Icon(Icons.person_outline_rounded, size: 18),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'İsim gerekli' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _numberController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Kart Numarası',
                        hintText: '•••• •••• •••• ••••',
                        prefixIcon: Icon(Icons.credit_card_rounded, size: 18),
                      ),
                      validator: (v) {
                        final digits = (v ?? '').replaceAll(RegExp(r'\D'), '');
                        return digits.length < 12 ? 'Geçersiz kart numarası' : null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _expiryController,
                            decoration: const InputDecoration(labelText: 'SKT', hintText: 'AA/YY'),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Gerekli' : null,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: TextFormField(
                            controller: _cvvController,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            decoration: const InputDecoration(labelText: 'CVV'),
                            validator: (v) => (v == null || v.trim().length < 3) ? 'Gerekli' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    GradientButton(label: 'Kartı Kaydet', icon: Icons.check_rounded, onPressed: _save),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
