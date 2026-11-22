import '../models/connector_type.dart';

/// Common BEV models for quick setup. Battery and consumption values are
/// representative catalog estimates; trims differ, and can be edited later.
class VehiclePreset {
  final String brand;
  final String model;
  final ConnectorType connector;
  final double batteryCapacityKwh;
  final double consumptionKwhPer100km;
  final String? note;

  const VehiclePreset({
    required this.brand,
    required this.model,
    required this.connector,
    required this.batteryCapacityKwh,
    required this.consumptionKwhPer100km,
    this.note,
  });

  String get label => '$brand $model';
  double get estimatedRangeKm =>
      batteryCapacityKwh / consumptionKwhPer100km * 100;
}

const vehiclePresets = <VehiclePreset>[
  VehiclePreset(
    brand: 'Audi',
    model: 'Q4 e-tron',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 77,
    consumptionKwhPer100km: 19,
  ),
  VehiclePreset(
    brand: 'BMW',
    model: 'i4',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 81,
    consumptionKwhPer100km: 18,
  ),
  VehiclePreset(
    brand: 'BMW',
    model: 'iX1',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 65,
    consumptionKwhPer100km: 18,
  ),
  VehiclePreset(
    brand: 'BYD',
    model: 'Atto 3',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 60,
    consumptionKwhPer100km: 17,
  ),
  VehiclePreset(
    brand: 'BYD',
    model: 'Dolphin',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 60,
    consumptionKwhPer100km: 16,
  ),
  VehiclePreset(
    brand: 'BYD',
    model: 'Han',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 85,
    consumptionKwhPer100km: 18,
  ),
  VehiclePreset(
    brand: 'BYD',
    model: 'Seal',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 82,
    consumptionKwhPer100km: 17,
  ),
  VehiclePreset(
    brand: 'BYD',
    model: 'Seal U',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 87,
    consumptionKwhPer100km: 20,
  ),
  VehiclePreset(
    brand: 'Citroën',
    model: 'ë-C3',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 44,
    consumptionKwhPer100km: 16,
  ),
  VehiclePreset(
    brand: 'Fiat',
    model: '500e',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 42,
    consumptionKwhPer100km: 16,
  ),
  VehiclePreset(
    brand: 'Ford',
    model: 'Mustang Mach-E',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 91,
    consumptionKwhPer100km: 21,
  ),
  VehiclePreset(
    brand: 'Hyundai',
    model: 'IONIQ 5',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 84,
    consumptionKwhPer100km: 19,
  ),
  VehiclePreset(
    brand: 'Hyundai',
    model: 'IONIQ 6',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 77,
    consumptionKwhPer100km: 16,
  ),
  VehiclePreset(
    brand: 'Hyundai',
    model: 'Kona Electric',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 65,
    consumptionKwhPer100km: 17,
  ),
  VehiclePreset(
    brand: 'Kia',
    model: 'EV3',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 81,
    consumptionKwhPer100km: 17,
  ),
  VehiclePreset(
    brand: 'Kia',
    model: 'EV6',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 84,
    consumptionKwhPer100km: 18,
  ),
  VehiclePreset(
    brand: 'Kia',
    model: 'Niro EV',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 65,
    consumptionKwhPer100km: 17,
  ),
  VehiclePreset(
    brand: 'Mercedes-Benz',
    model: 'EQA',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 70,
    consumptionKwhPer100km: 19,
  ),
  VehiclePreset(
    brand: 'MG',
    model: '4',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 64,
    consumptionKwhPer100km: 17,
  ),
  VehiclePreset(
    brand: 'MG',
    model: 'ZS EV',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 72,
    consumptionKwhPer100km: 18,
  ),
  VehiclePreset(
    brand: 'Mini',
    model: 'Cooper Electric',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 50,
    consumptionKwhPer100km: 16,
  ),
  VehiclePreset(
    brand: 'Nissan',
    model: 'Leaf',
    connector: ConnectorType.chademo,
    batteryCapacityKwh: 40,
    consumptionKwhPer100km: 17,
    note: 'Bazı sürümlerde CCS2 seçeneği bulunabilir.',
  ),
  VehiclePreset(
    brand: 'Opel',
    model: 'Corsa Electric',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 51,
    consumptionKwhPer100km: 16,
  ),
  VehiclePreset(
    brand: 'Opel',
    model: 'Mokka Electric',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 51,
    consumptionKwhPer100km: 17,
  ),
  VehiclePreset(
    brand: 'Peugeot',
    model: 'E-208',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 51,
    consumptionKwhPer100km: 16,
  ),
  VehiclePreset(
    brand: 'Peugeot',
    model: 'E-2008',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 51,
    consumptionKwhPer100km: 18,
  ),
  VehiclePreset(
    brand: 'Renault',
    model: '5 E-Tech',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 52,
    consumptionKwhPer100km: 16,
  ),
  VehiclePreset(
    brand: 'Renault',
    model: 'Megane E-Tech',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 60,
    consumptionKwhPer100km: 17,
  ),
  VehiclePreset(
    brand: 'Skoda',
    model: 'Enyaq',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 77,
    consumptionKwhPer100km: 19,
  ),
  VehiclePreset(
    brand: 'Tesla',
    model: 'Model 3',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 75,
    consumptionKwhPer100km: 15,
  ),
  VehiclePreset(
    brand: 'Tesla',
    model: 'Model Y',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 75,
    consumptionKwhPer100km: 17,
  ),
  VehiclePreset(
    brand: 'Togg',
    model: 'T10X',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 88.5,
    consumptionKwhPer100km: 19,
  ),
  VehiclePreset(
    brand: 'Togg',
    model: 'T10F',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 88.5,
    consumptionKwhPer100km: 19,
  ),
  VehiclePreset(
    brand: 'Volvo',
    model: 'EX30',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 69,
    consumptionKwhPer100km: 18,
  ),
  VehiclePreset(
    brand: 'Volkswagen',
    model: 'ID.4',
    connector: ConnectorType.ccs2,
    batteryCapacityKwh: 77,
    consumptionKwhPer100km: 19,
  ),
];
