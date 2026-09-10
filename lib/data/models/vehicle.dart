import 'connector_type.dart';

/// Kullanıcının kayıtlı elektrikli aracı — istasyon uyumluluğu ve menzil
/// tahmini için şarj akışında kullanılır.
class Vehicle {
  final String id;
  final String brand;
  final String model;
  final String plate;
  final ConnectorType connector;
  final double batteryCapacityKwh;
  final double consumptionKwhPer100km;
  final bool isDefault;

  const Vehicle({
    required this.id,
    required this.brand,
    required this.model,
    required this.plate,
    required this.connector,
    required this.batteryCapacityKwh,
    required this.consumptionKwhPer100km,
    this.isDefault = false,
  });

  double get estimatedRangeKm => (batteryCapacityKwh / consumptionKwhPer100km) * 100;

  Vehicle copyWith({bool? isDefault}) => Vehicle(
        id: id,
        brand: brand,
        model: model,
        plate: plate,
        connector: connector,
        batteryCapacityKwh: batteryCapacityKwh,
        consumptionKwhPer100km: consumptionKwhPer100km,
        isDefault: isDefault ?? this.isDefault,
      );
}
