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
