import 'package:flutter/material.dart';

import '../../../data/models/connector_type.dart';

/// Soket tipi ve en düşük güç. Liste ve harita aynı çubuğu kullanır.
class StationFilterBar extends StatelessWidget {
  final ConnectorType? connector;
  final double minKw;
  final ValueChanged<ConnectorType?> onConnector;
  final ValueChanged<double> onMinKw;

  const StationFilterBar({
    super.key,
    required this.connector,
    required this.minKw,
    required this.onConnector,
    required this.onMinKw,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final type in ConnectorType.values)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: FilterChip(
                label: Text(type.label),
                selected: connector == type,
                onSelected: (selected) => onConnector(selected ? type : null),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: FilterChip(
              label: const Text('50 kW+'),
              selected: minKw == 50,
              onSelected: (selected) => onMinKw(selected ? 50 : 0),
            ),
          ),
          FilterChip(
            label: const Text('150 kW+'),
            selected: minKw >= 150,
            onSelected: (selected) => onMinKw(selected ? 150 : 0),
          ),
        ],
      ),
    );
  }
}

/// İl, ilçe ve yakın çevre. Mesafe, cihaz konumu ölçülünce uygulanır.
class PlaceFilterBar extends StatelessWidget {
  final String? city;
  final String? district;
  final double? maxDistanceKm;
  final VoidCallback onPickPlace;
  final VoidCallback onNear;

  const PlaceFilterBar({
    super.key,
    required this.city,
    required this.district,
    required this.maxDistanceKm,
    required this.onPickPlace,
    required this.onNear,
  });

  @override
  Widget build(BuildContext context) {
    final place = district == null ? (city ?? 'İl') : '$district, $city';
    final nearLabel = maxDistanceKm == null ? 'Yakınımda' : 'Yakınımda · ${maxDistanceKm!.round()} km';
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(place),
              selected: city != null,
              onSelected: (_) => onPickPlace(),
            ),
          ),
          FilterChip(
            label: Text(nearLabel),
            selected: maxDistanceKm != null,
            onSelected: (_) => onNear(),
          ),
        ],
      ),
    );
  }
}
