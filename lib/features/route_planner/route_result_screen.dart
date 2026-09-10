import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock/city_distances.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/station.dart';
import '../../data/models/vehicle.dart';
import '../../widgets/bento_card.dart';
import '../../widgets/connector_chip.dart';
import '../stations/station_detail_screen.dart';

/// Şehirler arası rota sonucu — kaç şarj molası gerektiğini ve yol üzerinde
/// önerilen (aracın konnektörüyle uyumlu) istasyonları bir zaman çizelgesi
/// olarak gösterir.
class RouteResultScreen extends StatelessWidget {
  final String from;
  final String to;
  final Vehicle vehicle;

  const RouteResultScreen({super.key, required this.from, required this.to, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;

    final totalDistance = CityDistances.distanceKm(from, to).toDouble();
    // %80 güvenlik payıyla efektif menzil — tam bataryaya kadar sürmeyi
    // beklemek gerçekçi olmadığından yolculuk planlamasında standart bir
    // yaklaşımdır.
    final effectiveRange = vehicle.estimatedRangeKm * 0.8;
    final stopsNeeded = effectiveRange > 0 ? math.max(0, (totalDistance / effectiveRange).ceil() - 1) : 0;

    final compatibleStations = MockData.stations.where((s) => s.connectors.contains(vehicle.connector)).toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
    final stops = compatibleStations.take(stopsNeeded).toList();

    final segmentKm = stops.isEmpty ? totalDistance : totalDistance / (stops.length + 1);
    final drivingHours = totalDistance / 90;
    final chargeMinutesPerStop = [
      for (final s in stops) _estimateChargeMinutes(vehicle, s),
    ];
    final totalChargeMinutes = chargeMinutesPerStop.fold<int>(0, (sum, m) => sum + m);

    return Scaffold(
      appBar: AppBar(title: Text('$from → $to')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          BentoCard(
            child: Row(
              children: [
                Expanded(
                  child: _SummaryStat(
                    icon: Icons.route_rounded,
                    label: 'Mesafe',
                    value: '${totalDistance.toStringAsFixed(0)} km',
                  ),
                ),
                Expanded(
                  child: _SummaryStat(
                    icon: Icons.schedule_rounded,
                    label: 'Sürüş',
                    value: '${drivingHours.toStringAsFixed(1)} sa',
                  ),
                ),
                Expanded(
                  child: _SummaryStat(
                    icon: Icons.ev_station_rounded,
                    label: 'Şarj Molası',
                    value: '${stops.length}',
                  ),
                ),
                Expanded(
                  child: _SummaryStat(
                    icon: Icons.bolt_rounded,
                    label: 'Şarj Süresi',
                    value: totalChargeMinutes > 0 ? '~$totalChargeMinutes dk' : '—',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (stopsNeeded > stops.length)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: BentoCard(
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: colors.warning, size: 18),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        '${vehicle.connector.label} uyumlu $stopsNeeded istasyon gerekiyor, ancak yalnızca '
                        '${stops.length} tanesi bulundu. Rotanı gözden geçir.',
                        style: text.captionMuted.copyWith(color: colors.warning),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          _TimelineNode(
            icon: Icons.trip_origin_rounded,
            title: from,
            subtitle: 'Başlangıç · %100 şarj ile yola çık',
            color: colors.accentSecondary,
            isFirst: true,
          ),
          for (var i = 0; i < stops.length; i++) ...[
            _TimelineSegment(km: segmentKm),
            _TimelineStopCard(
              station: stops[i],
              chargeMinutes: chargeMinutesPerStop[i],
            ),
          ],
          _TimelineSegment(km: segmentKm),
          _TimelineNode(
            icon: Icons.flag_rounded,
            title: to,
            subtitle: 'Varış',
            color: colors.accentPrimary,
            isLast: true,
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  int _estimateChargeMinutes(Vehicle vehicle, Station station) {
    final energyNeededKwh = vehicle.batteryCapacityKwh * 0.55;
    final hours = energyNeededKwh / station.maxPowerKw;
    final minutes = (hours * 60).round();
    return minutes.clamp(15, 60);
  }
}

class _SummaryStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryStat({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    return Column(
      children: [
        Icon(icon, color: context.colors.accentPrimary, size: 18),
        const SizedBox(height: 4),
        Text(value, style: text.bodyStrong, textAlign: TextAlign.center),
        Text(label, style: text.captionMuted, textAlign: TextAlign.center),
      ],
    );
  }
}

class _TimelineNode extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool isFirst;
  final bool isLast;

  const _TimelineNode({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.16), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: text.bodyStrong),
              Text(subtitle, style: text.captionMuted),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineSegment extends StatelessWidget {
  final double km;

  const _TimelineSegment({required this.km});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Center(
              child: SizedBox(
                height: 28,
                child: VerticalDivider(color: colors.border, thickness: 1.4, width: 1),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text('${km.toStringAsFixed(0)} km', style: text.captionMuted),
        ],
      ),
    );
  }
}

class _TimelineStopCard extends StatelessWidget {
  final Station station;
  final int chargeMinutes;

  const _TimelineStopCard({required this.station, required this.chargeMinutes});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    return Padding(
      padding: const EdgeInsets.only(left: 44, bottom: AppSpacing.xs),
      child: BentoCard(
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => StationDetailScreen(station: station))),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.accentPrimary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(Icons.ev_station_rounded, color: colors.accentPrimary, size: 20),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(station.name, style: text.bodyStrong, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text('${station.chargeOperator.name} · ${station.maxPowerKw.toStringAsFixed(0)} kW', style: text.captionMuted),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      ConnectorChip(type: station.connectors.first),
                      const SizedBox(width: AppSpacing.xs),
                      Icon(Icons.timer_outlined, size: 13, color: colors.textMuted),
                      const SizedBox(width: 2),
                      Text('~$chargeMinutes dk şarj', style: text.captionMuted),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 18, color: colors.textMuted),
          ],
        ),
      ),
    );
  }
}
