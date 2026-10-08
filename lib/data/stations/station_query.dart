import '../models/connector_type.dart';
import '../models/station.dart';
import 'turkey_provinces.dart';

class DiscoveryFilter {
  final ConnectorType? connector;
  final double minKw;

  const DiscoveryFilter({this.connector, this.minKw = 0});

  bool get isActive => connector != null || minKw > 0;
}

class PlaceSelection {
  final String? city;
  final String? district;

  const PlaceSelection({this.city, this.district});
}

bool stationMatches(
  Station station, {
  required String query,
  String? city,
  String? district,
  double? maxDistanceKm,
  DiscoveryFilter filter = const DiscoveryFilter(),
}) {
  if (city != null && foldTr(station.city) != foldTr(city)) return false;
  if (district != null && foldTr(station.district) != foldTr(district)) return false;
  if (maxDistanceKm != null && station.distanceKm > maxDistanceKm) return false;
  if (filter.connector != null && !station.connectors.contains(filter.connector)) return false;
  if (filter.minKw > 0 && station.maxPowerKw < filter.minKw) return false;
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return true;
  return station.name.toLowerCase().contains(q) ||
      station.city.toLowerCase().contains(q) ||
      station.district.toLowerCase().contains(q) ||
      station.chargeOperator.name.toLowerCase().contains(q);
}
