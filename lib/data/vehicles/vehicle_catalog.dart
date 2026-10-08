import '../models/connector_type.dart';

/// Sık görülen binek araçlar. Rakamlar katalog önerisidir; plakayı kullanıcı yazar.
class VehiclePreset {
  final String brand;
  final String model;
  final ConnectorType connector;
  final double batteryCapacityKwh;
  final double consumptionKwhPer100km;

  const VehiclePreset({
    required this.brand,
    required this.model,
    required this.connector,
    required this.batteryCapacityKwh,
    required this.consumptionKwhPer100km,
  });

  String get label => '$brand $model';
}

const vehiclePresets = [
  VehiclePreset(
    brand: 'Togg',
    model: 'T10X',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 88.5,
    consumptionKwhPer100km: 18,
  ),
  VehiclePreset(
    brand: 'Tesla',
    model: 'Model Y',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 75,
    consumptionKwhPer100km: 16,
  ),
  VehiclePreset(
    brand: 'Renault',
    model: 'Megane E-Tech',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 60,
    consumptionKwhPer100km: 16,
  ),
  VehiclePreset(
    brand: 'BYD',
    model: 'Atto 3',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 60,
    consumptionKwhPer100km: 16,
  ),
  VehiclePreset(
    brand: 'Fiat',
    model: '500e',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 42,
    consumptionKwhPer100km: 15,
  ),
];
