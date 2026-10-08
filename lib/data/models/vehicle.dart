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

  Map<String, dynamic> toJson() => {
        'id': id,
        'brand': brand,
        'model': model,
        'plate': plate,
        'connector': connector.name,
        'batteryCapacityKwh': batteryCapacityKwh,
        'consumptionKwhPer100km': consumptionKwhPer100km,
        'isDefault': isDefault,
      };

  static Vehicle? tryParse(Map<String, dynamic> json) {
    try {
      ConnectorType? connector;
      for (final type in ConnectorType.values) {
        if (type.name == json['connector']) connector = type;
      }
      if (connector == null) return null;
      return Vehicle(
        id: json['id'] as String,
        brand: json['brand'] as String,
        model: json['model'] as String,
        plate: json['plate'] as String? ?? '',
        connector: connector,
        batteryCapacityKwh: (json['batteryCapacityKwh'] as num).toDouble(),
        consumptionKwhPer100km: (json['consumptionKwhPer100km'] as num).toDouble(),
        isDefault: json['isDefault'] == true,
      );
    } catch (_) {
      return null;
    }
  }
}
