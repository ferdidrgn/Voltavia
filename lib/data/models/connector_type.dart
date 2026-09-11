import 'package:flutter/material.dart';

enum ConnectorType {
  ccs2('CCS2', Icons.ev_station),
  type2('Type 2', Icons.power),
  chademo('CHAdeMO', Icons.bolt),
  ac('AC Priz', Icons.electrical_services);

  final String label;
  final IconData icon;

  const ConnectorType(this.label, this.icon);
}

enum StationStatus {
  available('Müsait'),
  busy('Dolu'),
  offline('Çevrimdışı'),
  maintenance('Bakımda');

  final String label;

  const StationStatus(this.label);
}
