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
  });

  bool get canStartFromApp => chargeOperator.hasAppIntegration && status == StationStatus.available;
}
