import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../core/theme/app_palette.dart';
import '../../data/models/station.dart';

/// OpenStreetMap karoları üzerinde EPDK ve OSM istasyonları.
class StationMap extends StatefulWidget {
  final List<Station> stations;
  final Station? selected;
  final ValueChanged<Station> onSelect;
  final MapController? controller;

  const StationMap({
    super.key,
    required this.stations,
    required this.onSelect,
    this.selected,
    this.controller,
  });

  @override
  State<StationMap> createState() => _StationMapState();
}

class _StationMapState extends State<StationMap> {
  MapController? _owned;

  MapController get _controller => widget.controller ?? (_owned ??= MapController());

  @override
  void dispose() {
    _owned?.dispose();
    super.dispose();
  }

  void _pickNearest(LatLng point) {
    if (widget.stations.isEmpty) return;
    final zoom = _controller.camera.zoom;
    final pxPerDeg = 256 * math.pow(2, zoom) / 360.0;
    final hit = 18 / pxPerDeg;
    final cos = math.cos(point.latitude * math.pi / 180);
    Station? best;
    var bestD = hit * hit;
    for (final station in widget.stations) {
      final dLat = station.latitude - point.latitude;
      final dLon = (station.longitude - point.longitude) * cos;
      final d = dLat * dLat + dLon * dLon;
      if (d < bestD) {
        bestD = d;
        best = station;
      }
    }
    if (best != null) widget.onSelect(best);
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;
    return Stack(
      children: [
        FlutterMap(
          mapController: _controller,
          options: MapOptions(
            initialCenter: const LatLng(39.2, 32.8),
            initialZoom: 6.2,
            minZoom: 5,
            maxZoom: 18,
            onTap: (_, point) => _pickNearest(point),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'dev.voltavia.app',
            ),
            CircleLayer(
              circles: [
                for (final station in widget.stations)
                  CircleMarker(
                    point: LatLng(station.latitude, station.longitude),
                    radius: selected?.id == station.id ? 9 : 5.5,
                    color: _originColor(station.origin),
                    borderStrokeWidth: selected?.id == station.id ? 2.5 : 1.2,
                    borderColor: selected?.id == station.id ? AppPalette.porcelain : Colors.white,
                  ),
              ],
            ),
            const RichAttributionWidget(
              attributions: [
                TextSourceAttribution('OpenStreetMap · EPDK / İBB açık veri'),
              ],
            ),
          ],
        ),
        const Positioned(
          left: 12,
          bottom: 28,
          child: _SourceLegend(),
        ),
      ],
    );
  }
}

Color _originColor(String origin) {
  if (origin.contains('+')) return AppPalette.volt;
  if (origin.startsWith('EPDK')) return AppPalette.sodium;
  if (origin == 'OpenStreetMap') return AppPalette.seaGlass;
  return AppPalette.current;
}

class _SourceLegend extends StatelessWidget {
  const _SourceLegend();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppPalette.night.withValues(alpha: 0.88),
      borderRadius: BorderRadius.circular(12),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _LegendRow(color: AppPalette.sodium, label: 'EPDK'),
            SizedBox(height: 4),
            _LegendRow(color: AppPalette.seaGlass, label: 'OpenStreetMap'),
            SizedBox(height: 4),
            _LegendRow(color: AppPalette.volt, label: 'İkisinde de var'),
          ],
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendRow({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1)),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: AppPalette.porcelain, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
