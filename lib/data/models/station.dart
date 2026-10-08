import 'connector_type.dart';
import 'operator.dart';

class Station {
  final String id;
  final String name;
  final String city;
  final String district;
  final String address;
  final ChargeOperator chargeOperator;
  final List<ConnectorType> connectors;
  final double maxPowerKw;
  final double pricePerKwh;
  final StationStatus status;
  final double distanceKm;
  final double rating;
  final int socketCount;
  final double latitude;
  final double longitude;
  final String origin;

  const Station({
    required this.id,
    required this.name,
    required this.city,
    required this.district,
    required this.address,
    required this.chargeOperator,
    required this.connectors,
    required this.maxPowerKw,
    required this.pricePerKwh,
    required this.status,
    required this.distanceKm,
    required this.rating,
    required this.socketCount,
    this.latitude = 41.015137,
    this.longitude = 28.979530,
    this.origin = 'Örnek',
  });

  bool get canStartFromApp => chargeOperator.hasAppIntegration && status == StationStatus.available;

  Station withDistance(double km) {
    return Station(
      id: id,
      name: name,
      city: city,
      district: district,
      address: address,
      chargeOperator: chargeOperator,
      connectors: connectors,
      maxPowerKw: maxPowerKw,
      pricePerKwh: pricePerKwh,
      status: status,
      distanceKm: km,
      rating: rating,
      socketCount: socketCount,
      latitude: latitude,
      longitude: longitude,
      origin: origin,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'city': city,
        'district': district,
        'address': address,
        'connectors': [for (final connector in connectors) connector.name],
        'maxPowerKw': maxPowerKw,
        'pricePerKwh': pricePerKwh,
        'status': status.name,
        'distanceKm': distanceKm,
        'rating': rating,
        'socketCount': socketCount,
        'latitude': latitude,
        'longitude': longitude,
        'origin': origin,
        'operator': {
          'id': chargeOperator.id,
          'name': chargeOperator.name,
          'logoLetter': chargeOperator.logoLetter,
          'hasAppIntegration': chargeOperator.hasAppIntegration,
          'description': chargeOperator.description,
        },
      };

  static Station? tryParse(Map<String, dynamic> json) {
    try {
      final operator = json['operator'];
      if (operator is! Map) return null;
      final connectors = <ConnectorType>[];
      final rawConnectors = json['connectors'];
      if (rawConnectors is List) {
        for (final name in rawConnectors) {
          for (final type in ConnectorType.values) {
            if (type.name == name) connectors.add(type);
          }
        }
      }
      var status = StationStatus.unknown;
      for (final value in StationStatus.values) {
        if (value.name == json['status']) status = value;
      }
      return Station(
        id: json['id'] as String,
        name: json['name'] as String,
        city: json['city'] as String? ?? '',
        district: json['district'] as String? ?? '',
        address: json['address'] as String? ?? '',
        chargeOperator: ChargeOperator(
          id: operator['id'] as String,
          name: operator['name'] as String,
          logoLetter: operator['logoLetter'] as String? ?? '?',
          hasAppIntegration: operator['hasAppIntegration'] == true,
          description: operator['description'] as String? ?? '',
        ),
        connectors: connectors,
        maxPowerKw: (json['maxPowerKw'] as num?)?.toDouble() ?? 0,
        pricePerKwh: (json['pricePerKwh'] as num?)?.toDouble() ?? 0,
        status: status,
        distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0,
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        socketCount: (json['socketCount'] as num?)?.toInt() ?? connectors.length,
        latitude: (json['latitude'] as num?)?.toDouble() ?? 41.015137,
        longitude: (json['longitude'] as num?)?.toDouble() ?? 28.979530,
        origin: json['origin'] as String? ?? 'Önbellek',
      );
    } catch (_) {
      return null;
    }
  }
}
