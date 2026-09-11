import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_palette.dart';
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
              decoration: BoxDecoration(
                color: colors.success.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: colors.success.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bolt_rounded, color: colors.success, size: 13),
                  const SizedBox(width: 3),
                  Text(
                    'ŞARJ EDİLİYOR',
                    style: text.captionMuted.copyWith(color: colors.success, fontWeight: FontWeight.w800, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(station?.name ?? 'İstasyon', style: text.headline, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(station?.chargeOperator.name ?? '', style: text.bodyMuted),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: 240,
              height: 240,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: colors.accentPrimary.withValues(alpha: 0.35), blurRadius: 60, spreadRadius: 6),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: CircularProgressIndicator(
                      value: 1,
                      strokeWidth: 14,
                      backgroundColor: colors.border,
                      valueColor: AlwaysStoppedAnimation(colors.border),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: ShaderMask(
                      shaderCallback: (bounds) => const SweepGradient(
                        startAngle: -1.5708,
                        endAngle: 4.7124,
                        colors: [...AppPalette.indigoGradient, ...AppPalette.voltGradient],
                        stops: [0, 0.5, 0.5, 1],
                      ).createShader(bounds),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: _batteryPercent / 100),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOut,
                        builder: (context, value, _) => CircularProgressIndicator(
                          value: value,
                          strokeWidth: 14,
                          backgroundColor: Colors.transparent,
                          valueColor: const AlwaysStoppedAnimation(Colors.white),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            const LinearGradient(colors: AppPalette.indigoGradient).createShader(bounds),
                        child: Icon(Icons.bolt_rounded, color: Colors.white, size: 28),
                      ),
                      Text('%${_batteryPercent.toStringAsFixed(0)}', style: text.numericLg),
                      Text('şarj seviyesi', style: text.captionMuted),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _MetricTile(
                      icon: Icons.timer_rounded,
                      label: 'Süre',
                      value: Formatters.duration(elapsed),
                      accent: colors.accentPrimary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _MetricTile(
                      icon: Icons.bolt_rounded,
                      label: 'Enerji',
                      value: Formatters.kwh(_kwh),
                      accent: colors.accentSecondary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _MetricTile(
                      icon: Icons.credit_card_rounded,
                      label: 'Tutar',
                      value: Formatters.tryPrice(cost),
                      accent: AppPalette.pink,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: _stop,
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.danger,
                  side: BorderSide(color: colors.danger.withValues(alpha: 0.5), width: 1.4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
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
  final Color accent;

  const _MetricTile({required this.icon, required this.label, required this.value, required this.accent});

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    return BentoCard(
      glowColor: accent,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.xs),
      child: Column(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [accent, Color.lerp(accent, Colors.black, 0.25)!],
              ),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, color: Colors.white, size: 17),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: text.bodyStrong, textAlign: TextAlign.center),
          Text(label, style: text.captionMuted),
        ],
      ),
    );
  }
}
