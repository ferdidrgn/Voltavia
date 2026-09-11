import 'package:flutter/material.dart';

import '../../core/theme/app_palette.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/connector_type.dart';
import '../../data/models/station.dart';
import '../../widgets/map_grid_background.dart';
import '../../widgets/status_badge.dart';
import '../stations/station_detail_screen.dart';
import '../stations/widgets/city_filter_sheet.dart';

const _pinPositions = <String, Offset>{
  's1': Offset(0.30, 0.28),
  's2': Offset(0.62, 0.18),
  's3': Offset(0.20, 0.62),
  's4': Offset(0.72, 0.55),
  's5': Offset(0.48, 0.42),
  's6': Offset(0.55, 0.75),
  's7': Offset(0.15, 0.40),
  's8': Offset(0.80, 0.30),
  's9': Offset(0.35, 0.80),
  's10': Offset(0.65, 0.60),
};

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String? _selectedCity;
  Station? _selected;

  List<Station> get _visibleStations {
    if (_selectedCity == null) return MockData.stations;
    return MockData.stations.where((s) => s.city == _selectedCity).toList();
  }

  Color _pinColor(BuildContext context, StationStatus status) {
    final c = context.colors;
    switch (status) {
      case StationStatus.available:
        return c.success;
      case StationStatus.busy:
        return c.danger;
      case StationStatus.offline:
        return c.textMuted;
      case StationStatus.maintenance:
        return c.warning;
    }
  }

  Future<void> _openCityFilter() async {
    final city = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      builder: (_) => CityFilterSheet(selectedCity: _selectedCity),
    );
    if (!mounted) return;
    setState(() => _selectedCity = city);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: MapGridBackground(baseColor: colors.canvas, lineColor: colors.accentPrimary),
          ),
          for (final station in _visibleStations)
            if (_pinPositions[station.id] != null)
              _MapPin(
                alignment: _pinPositions[station.id]!,
                color: _pinColor(context, station.status),
                selected: _selected?.id == station.id,
                onTap: () => setState(() => _selected = station),
              ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                            border: Border.all(color: colors.border),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.24), blurRadius: 16, offset: const Offset(0, 6)),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search_rounded, color: colors.textMuted, size: 19),
                              const SizedBox(width: AppSpacing.xs),
                              Expanded(
                                child: Text(
                                  _selectedCity == null ? 'İstasyon veya bölge ara' : '$_selectedCity içinde ara',
                                  style: TextStyle(color: colors.textMuted, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _RoundIconButton(
                        icon: Icons.tune_rounded,
                        highlighted: _selectedCity != null,
                        onTap: _openCityFilter,
                      ),
                    ],
                  ),
                  if (_selectedCity != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Chip(
                        label: Text(_selectedCity!),
                        avatar: Icon(Icons.apartment_rounded, size: 15, color: colors.accentPrimary),
                        onDeleted: () => setState(() => _selectedCity = null),
                        backgroundColor: colors.surface,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            right: AppSpacing.md,
            bottom: _selected != null ? 200 : AppSpacing.lg,
            child: _RoundIconButton(icon: Icons.navigation_rounded, onTap: () {}),
          ),
          if (_selected != null)
            Positioned(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSpacing.md,
              child: _StationPreviewCard(
                station: _selected!,
                onClose: () => setState(() => _selected = null),
                onOpen: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => StationDetailScreen(station: _selected!)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  final Offset alignment;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _MapPin({required this.alignment, required this.color, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(alignment.dx * 2 - 1, alignment.dy * 2 - 1),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          scale: selected ? 1.15 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Container(
            width: selected ? 40 : 32,
            height: selected ? 40 : 32,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 10, spreadRadius: 1)],
            ),
            child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 16),
          ),
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool highlighted;

  const _RoundIconButton({required this.icon, required this.onTap, this.highlighted = false});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: highlighted ? colors.accentPrimary : colors.surface,
      shape: CircleBorder(side: BorderSide(color: colors.border)),
      elevation: 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Icon(icon, size: 19, color: highlighted ? Colors.white : colors.textMuted),
        ),
      ),
    );
  }
}

class _StationPreviewCard extends StatelessWidget {
  final Station station;
  final VoidCallback onClose;
  final VoidCallback onOpen;

  const _StationPreviewCard({required this.station, required this.onClose, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onOpen,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: AppPalette.indigoGradient),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                alignment: Alignment.center,
                child: Text(
                  station.chargeOperator.logoLetter,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(station.name, style: text.bodyStrong, maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                        StatusBadge(status: station.status, compact: true),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${station.chargeOperator.name} · ${Formatters.km(station.distanceKm)} · ${Formatters.tryPrice(station.pricePerKwh)}/kWh',
                      style: text.captionMuted,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              IconButton(onPressed: onClose, icon: Icon(Icons.close_rounded, size: 17, color: colors.textMuted)),
            ],
          ),
        ),
      ),
    );
  }
}
