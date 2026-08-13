import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius_extension.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
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
    final muted = context.voltaviaColors.textMuted;
    final elapsed = DateTime.now().difference(_startedAt);
    final cost = _kwh * _pricePerKwh;

    return Scaffold(
      appBar: AppBar(title: const Text('Aktif Şarj')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Text(
              station?.name ?? 'İstasyon',
              style: AppTextStyles.headline,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              station?.chargeOperator.name ?? '',
              style: AppTextStyles.body.copyWith(color: muted),
            ),
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
                      backgroundColor: context.voltaviaColors.border,
                      valueColor: const AlwaysStoppedAnimation(AppColors.brandPrimary),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bolt_rounded, color: AppColors.brandSecondary, size: 28),
                      Text(
                        '%${_batteryPercent.toStringAsFixed(0)}',
                        style: AppTextStyles.numeric,
                      ),
                      Text('şarj seviyesi', style: AppTextStyles.caption.copyWith(color: muted)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    icon: Icons.timer_outlined,
                    label: 'Süre',
                    value: Formatters.duration(elapsed),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _MetricTile(
                    icon: Icons.electric_bolt_outlined,
                    label: 'Enerji',
                    value: Formatters.kwh(_kwh),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _MetricTile(
                    icon: Icons.payments_outlined,
                    label: 'Tutar',
                    value: Formatters.tryPrice(cost),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _stop,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.statusBusy,
                  side: const BorderSide(color: AppColors.statusBusy),
                ),
                icon: const Icon(Icons.stop_circle_outlined),
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
    final muted = context.voltaviaColors.textMuted;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.xs),
      decoration: BoxDecoration(
        color: context.voltaviaColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.voltaviaColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.brandPrimary, size: 20),
          const SizedBox(height: AppSpacing.xxs),
          Text(value, style: AppTextStyles.bodyStrong, textAlign: TextAlign.center),
          Text(label, style: AppTextStyles.caption.copyWith(color: muted)),
        ],
      ),
    );
  }
}
