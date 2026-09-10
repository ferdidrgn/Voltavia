import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/connector_type.dart';
import '../../data/models/vehicle.dart';
import '../../widgets/gradient_button.dart';

/// Kullanıcının aracını kaydettiği form — konnektör tipi ve batarya
/// kapasitesi, şarj akışındaki uyumluluk/menzil tahminlerini besler.
class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _plateController = TextEditingController();
  final _batteryController = TextEditingController(text: '60');
  final _consumptionController = TextEditingController(text: '16');
  ConnectorType _connector = ConnectorType.ccs2;

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _plateController.dispose();
    _batteryController.dispose();
    _consumptionController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final appState = AppStateScope.of(context);
    appState.addVehicle(
      Vehicle(
        id: 'v-${DateTime.now().millisecondsSinceEpoch}',
        brand: _brandController.text.trim(),
        model: _modelController.text.trim(),
        plate: _plateController.text.trim(),
        connector: _connector,
        batteryCapacityKwh: double.tryParse(_batteryController.text.replaceAll(',', '.')) ?? 60,
        consumptionKwhPer100km: double.tryParse(_consumptionController.text.replaceAll(',', '.')) ?? 16,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    return Scaffold(
      appBar: AppBar(title: const Text('Araç Ekle')),
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
                    TextFormField(
                      controller: _brandController,
                      decoration: const InputDecoration(
                        labelText: 'Marka',
                        hintText: 'Tesla, Renault, BYD…',
                        prefixIcon: Icon(Icons.directions_car_filled_outlined, size: 18),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Marka gerekli' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _modelController,
                      decoration: const InputDecoration(
                        labelText: 'Model',
                        hintText: 'Model 3, Megane E-Tech…',
                        prefixIcon: Icon(Icons.directions_car_outlined, size: 18),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Model gerekli' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _plateController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        labelText: 'Plaka',
                        hintText: '34 VT 3453',
                        prefixIcon: Icon(Icons.pin_outlined, size: 18),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Plaka gerekli' : null,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text('Konnektör Tipi', style: text.bodyStrong),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        for (final c in ConnectorType.values)
                          ChoiceChip(
                            label: Text(c.label),
                            avatar: Icon(c.icon, size: 16),
                            selected: _connector == c,
                            onSelected: (_) => setState(() => _connector = c),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _batteryController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Batarya (kWh)',
                              prefixIcon: Icon(Icons.battery_charging_full_rounded, size: 18),
                            ),
                            validator: (v) =>
                                (double.tryParse((v ?? '').replaceAll(',', '.')) == null) ? 'Geçersiz' : null,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: TextFormField(
                            controller: _consumptionController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Tüketim (kWh/100km)',
                              prefixIcon: Icon(Icons.speed_rounded, size: 18),
                            ),
                            validator: (v) =>
                                (double.tryParse((v ?? '').replaceAll(',', '.')) == null) ? 'Geçersiz' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    GradientButton(label: 'Aracı Kaydet', icon: Icons.check_rounded, onPressed: _save),
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
