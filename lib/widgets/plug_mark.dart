import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme/app_palette.dart';

/// Şarj soketinin sadeleştirilmiş yüzü. Voltavia'nın hatırlanan işareti:
/// porselen halka, iki pin ve ilerlemeyle yanan sodyum ark.
class PlugMark extends StatelessWidget {
  final double size;
  final double progress;
  final bool animate;

  const PlugMark({
    super.key,
    this.size = 96,
    this.progress = 1,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.disableAnimationsOf(context);
    if (!animate || reduce) {
      return CustomPaint(
        size: Size.square(size),
        painter: PlugMarkPainter(progress: progress, pulse: 0),
      );
    }
    return _PulsingPlug(size: size, progress: progress);
  }
}

class _PulsingPlug extends StatefulWidget {
  final double size;
  final double progress;

  const _PulsingPlug({required this.size, required this.progress});

  @override
  State<_PulsingPlug> createState() => _PulsingPlugState();
}

class _PulsingPlugState extends State<_PulsingPlug> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: Size.square(widget.size),
          painter: PlugMarkPainter(progress: widget.progress, pulse: _controller.value),
        );
      },
    );
  }
}

class PlugMarkPainter extends CustomPainter {
  final double progress;
  final double pulse;

  PlugMarkPainter({required this.progress, required this.pulse});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.46;
    final clamped = progress.clamp(0.0, 1.0);

    final glow = Paint()
      ..color = AppPalette.sodium.withValues(alpha: 0.18 + pulse * 0.12)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, size.width * 0.08);
    canvas.drawCircle(c, radius * (0.92 + pulse * 0.04), glow);

    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.045
      ..color = AppPalette.seaGlass.withValues(alpha: 0.45);
    canvas.drawCircle(c, radius, ring);

    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.05
      ..strokeCap = StrokeCap.round
      ..color = AppPalette.sodium;
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: radius),
      -math.pi / 2,
      math.pi * 2 * clamped,
      false,
      arc,
    );

    final face = Paint()..color = AppPalette.harbor;
    canvas.drawCircle(c, radius * 0.78, face);

    final pinPaint = Paint()..color = Color.lerp(AppPalette.tide, AppPalette.sodium, clamped)!;
    final pinW = size.width * 0.11;
    final pinH = size.width * 0.22;
    final gap = size.width * 0.12;
    final pinRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(c.dx - gap, c.dy), width: pinW, height: pinH),
      Radius.circular(pinW),
    );
    canvas.drawRRect(pinRect, pinPaint);
    canvas.drawRRect(pinRect.shift(Offset(gap * 2, 0)), pinPaint);

    canvas.drawCircle(Offset(c.dx, c.dy + size.height * 0.2), size.width * 0.035, Paint()..color = AppPalette.sodiumSoft);
  }

  @override
  bool shouldRepaint(PlugMarkPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.pulse != pulse;
}
