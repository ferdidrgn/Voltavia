import 'package:flutter/material.dart';

/// Ana sayfadaki kampanya/duyuru slider'ında gösterilen kart.
class Campaign {
  final String id;
  final String title;
  final String subtitle;
  final String ctaLabel;
  final IconData icon;
  final List<Color> colors;

  const Campaign({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    required this.icon,
    required this.colors,
  });
}
