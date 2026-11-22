import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/connector_type.dart';
import '../../data/models/vehicle.dart';
import '../../data/vehicles/vehicle_catalog.dart';
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
  VehiclePreset? _selectedPreset;

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
        plate: _plateController.text.trim().toUpperCase(),
        connector: _connector,
        batteryCapacityKwh:
            double.tryParse(_batteryController.text.replaceAll(',', '.')) ?? 60,
        consumptionKwhPer100km:
            double.tryParse(_consumptionController.text.replaceAll(',', '.')) ??
            16,
      ),
    );
    Navigator.of(context).pop();
  }

  Future<void> _chooseFromCatalog() async {
    final preset = await showDialog<VehiclePreset>(
      context: context,
      builder: (_) => const _VehicleCatalogDialog(),
    );
    if (preset == null || !mounted) return;
    setState(() {
      _selectedPreset = preset;
      _brandController.text = preset.brand;
      _modelController.text = preset.model;
      _batteryController.text = preset.batteryCapacityKwh.toString();
      _consumptionController.text = preset.consumptionKwhPer100km.toString();
      _connector = preset.connector;
    });
  }

  void _refreshPresetSummary(String _) {
    final current = _selectedPreset;
    if (current == null) return;
    final battery =
        double.tryParse(_batteryController.text.replaceAll(',', '.')) ??
        current.batteryCapacityKwh;
    final consumption =
        double.tryParse(_consumptionController.text.replaceAll(',', '.')) ??
        current.consumptionKwhPer100km;
    setState(() {
      _selectedPreset = VehiclePreset(
        brand: _brandController.text.trim().isEmpty
            ? current.brand
            : _brandController.text.trim(),
        model: _modelController.text.trim().isEmpty
            ? current.model
            : _modelController.text.trim(),
        connector: _connector,
        batteryCapacityKwh: battery,
        consumptionKwhPer100km: consumption,
      );
    });
  }

  void _setConnector(ConnectorType connector) {
    setState(() {
      _connector = connector;
      final current = _selectedPreset;
      if (current != null) {
        _selectedPreset = VehiclePreset(
          brand: _brandController.text.trim().isEmpty
              ? current.brand
              : _brandController.text.trim(),
          model: _modelController.text.trim().isEmpty
              ? current.model
              : _modelController.text.trim(),
          connector: connector,
          batteryCapacityKwh:
              double.tryParse(_batteryController.text.replaceAll(',', '.')) ??
              current.batteryCapacityKwh,
          consumptionKwhPer100km:
              double.tryParse(
                _consumptionController.text.replaceAll(',', '.'),
              ) ??
              current.consumptionKwhPer100km,
        );
      }
    });
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
                    Text('Elektrikli araç kataloğu', style: text.bodyStrong),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Marka veya model ara; teknik değerleri istersen kaydetmeden önce değiştirebilirsin.',
                      style: text.captionMuted,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _CatalogPickerButton(
                      selected: _selectedPreset,
                      onTap: _chooseFromCatalog,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _brandController,
                      decoration: const InputDecoration(
                        labelText: 'Marka',
                        hintText: 'Tesla, Renault, BYD…',
                        prefixIcon: Icon(
                          Icons.directions_car_filled_outlined,
                          size: 18,
                        ),
                      ),
                      onChanged: _refreshPresetSummary,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Marka gerekli'
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _modelController,
                      decoration: const InputDecoration(
                        labelText: 'Model',
                        hintText: 'Model 3, Megane E-Tech…',
                        prefixIcon: Icon(
                          Icons.directions_car_outlined,
                          size: 18,
                        ),
                      ),
                      onChanged: _refreshPresetSummary,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Model gerekli'
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _plateController,
                      decoration: const InputDecoration(
                        labelText: 'Plaka (isteğe bağlı)',
                        hintText: '34 VT 3453',
                        prefixIcon: Icon(Icons.pin_outlined, size: 18),
                      ),
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
                            onSelected: (_) => _setConnector(c),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _batteryController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Batarya (kWh)',
                              prefixIcon: Icon(
                                Icons.battery_charging_full_rounded,
                                size: 18,
                              ),
                            ),
                            onChanged: _refreshPresetSummary,
                            validator: (v) {
                              final value = double.tryParse(
                                (v ?? '').replaceAll(',', '.'),
                              );
                              return value == null || value <= 0
                                  ? '0’dan büyük olmalı'
                                  : null;
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: TextFormField(
                            controller: _consumptionController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Tüketim (kWh/100km)',
                              prefixIcon: Icon(Icons.speed_rounded, size: 18),
                            ),
                            onChanged: _refreshPresetSummary,
                            validator: (v) {
                              final value = double.tryParse(
                                (v ?? '').replaceAll(',', '.'),
                              );
                              return value == null || value <= 0
                                  ? '0’dan büyük olmalı'
                                  : null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    GradientButton(
                      label: 'Aracı Kaydet',
                      icon: Icons.check_rounded,
                      onPressed: _save,
                    ),
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

class _CatalogPickerButton extends StatelessWidget {
  final VehiclePreset? selected;
  final VoidCallback onTap;

  const _CatalogPickerButton({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.borderStrong),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppPalette.volt.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.electric_car_rounded, color: AppPalette.volt),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(selected?.label ?? 'Araç seç', style: text.bodyStrong),
                    Text(
                      selected == null
                          ? '${vehiclePresets.length} elektrikli model • kataloğu aç'
                          : '${selected!.batteryCapacityKwh.toStringAsFixed(0)} kWh • ${selected!.connector.label} • yaklaşık ${selected!.estimatedRangeKm.toStringAsFixed(0)} km',
                      style: text.captionMuted,
                    ),
                  ],
                ),
              ),
              Icon(Icons.search_rounded, color: colors.accentPrimary),
            ],
          ),
        ),
      ),
    );
  }
}

class _VehicleCatalogDialog extends StatefulWidget {
  const _VehicleCatalogDialog();

  @override
  State<_VehicleCatalogDialog> createState() => _VehicleCatalogDialogState();
}

class _VehicleCatalogDialogState extends State<_VehicleCatalogDialog> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final query = _search.text.trim().toLowerCase();
    final results =
        vehiclePresets
            .where((vehicle) => vehicle.label.toLowerCase().contains(query))
            .toList()
          ..sort((a, b) => a.label.compareTo(b.label));
    final brands = vehiclePresets
        .map((vehicle) => vehicle.brand)
        .toSet()
        .length;
    return AlertDialog(
      title: const Text('Aracını katalogdan seç'),
      content: SizedBox(
        width: 520,
        height: (MediaQuery.sizeOf(context).height * .72).clamp(320.0, 560.0),
        child: Column(
          children: [
            Text(
              '${vehiclePresets.length} model • $brands marka • batarya ve menzil tahmini hazır',
              style: context.text.captionMuted,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _search,
              autofocus: true,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Örn. Togg, Tesla, IONIQ…',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _search.clear();
                          setState(() {});
                        },
                      ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: results.isEmpty
                  ? Center(
                      child: Text(
                        'Eşleşme yok. Kapatıp marka ve model alanlarını elle doldurabilirsin.',
                        style: context.text.bodyMuted,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.separated(
                      itemCount: results.length,
                      separatorBuilder: (_, _) =>
                          Divider(height: 1, color: colors.border),
                      itemBuilder: (context, index) {
                        final vehicle = results[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: AppPalette.volt.withValues(
                              alpha: .12,
                            ),
                            child: Icon(
                              Icons.electric_car_rounded,
                              color: AppPalette.volt,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            vehicle.label,
                            style: context.text.bodyStrong,
                          ),
                          subtitle: Text(
                            '${vehicle.batteryCapacityKwh.toStringAsFixed(0)} kWh  •  ~${vehicle.estimatedRangeKm.toStringAsFixed(0)} km  •  ${vehicle.connector.label}${vehicle.note == null ? '' : '\n${vehicle.note}'}',
                          ),
                          isThreeLine: vehicle.note != null,
                          trailing: const Icon(
                            Icons.add_circle_outline_rounded,
                          ),
                          onTap: () => Navigator.of(context).pop(vehicle),
                        );
                      },
                    ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Değerler donanım paketine göre değişebilir; formda düzenleyebilirsin.',
              style: context.text.captionMuted,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Kapat'),
        ),
      ],
    );
  }
}
