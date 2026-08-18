import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_semantic_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../widgets/bento_card.dart';
import 'session_summary_screen.dart';

class ActiveChargingScreen extends StatefulWidget {
  const ActiveChargingScreen({super.key});

  @override
  State<ActiveChargingScreen> createState() => _ActiveChargingScreenState();
}

class _ActiveChargingScreenState extends State<ActiveChargingScreen> {
  Timer? _timer;
  double _kwh = 0;
  double _batteryPercent = 34;
  DateTime _startedAt = DateTime.now();
  bool _initialized = false;

  static const _pricePerKwh = 8.9;
  static const _targetPercent = 90.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _startedAt = AppStateScope.of(context).activeSession?.startedAt ?? DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _kwh += 0.045;
        if (_batteryPercent < _targetPercent) {
          _batteryPercent += 0.12;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _stop() {
    _timer?.cancel();
    final appState = AppStateScope.of(context);
    final station = appState.activeStation!;
    appState.stopSession();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => SessionSummaryScreen(
          stationName: station.name,
          operatorName: station.chargeOperator.name,
          energyKwh: _kwh,
          costTry: _kwh * _pricePerKwh,
          duration: DateTime.now().difference(_startedAt),
        ),
      ),
    );
    appState.clearSession();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final station = appState.activeStation;
    final colors = context.colors;
    final text = context.text;
    final elapsed = DateTime.now().difference(_startedAt);
    final cost = _kwh * _pricePerKwh;

    return Scaffold(
      appBar: AppBar(title: const Text('Aktif Şarj')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Text(station?.name ?? 'İstasyon', style: text.headline, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(station?.chargeOperator.name ?? '', style: text.bodyMuted),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: 220,
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: CircularProgressIndicator(
                      value: _batteryPercent / 100,
                      strokeWidth: 14,
                      backgroundColor: colors.border,
                      valueColor: AlwaysStoppedAnimation(colors.accentPrimary),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.zap, color: colors.accentSecondary, size: 26),
                      Text('%${_batteryPercent.toStringAsFixed(0)}', style: text.numericLg),
                      Text('şarj seviyesi', style: text.captionMuted),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: _MetricTile(icon: LucideIcons.timer, label: 'Süre', value: Formatters.duration(elapsed)),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _MetricTile(icon: LucideIcons.zap, label: 'Enerji', value: Formatters.kwh(_kwh)),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _MetricTile(icon: LucideIcons.creditCard, label: 'Tutar', value: Formatters.tryPrice(cost)),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _stop,
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.danger,
                  side: BorderSide(color: colors.danger.withValues(alpha: 0.5)),
                ),
                icon: const Icon(Icons.stop_circle_outlined, size: 19),
                label: const Text('Şarjı Durdur'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetricTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    return BentoCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.xs),
      child: Column(
        children: [
          Icon(icon, color: context.colors.accentPrimary, size: 20),
          const SizedBox(height: AppSpacing.xxs),
          Text(value, style: text.bodyStrong, textAlign: TextAlign.center),
          Text(label, style: text.captionMuted),
        ],
      ),
    );
  }
}
