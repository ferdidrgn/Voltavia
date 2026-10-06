import 'package:flutter/material.dart';

import '../core/theme/app_palette.dart';
import '../core/theme/app_semantic_colors.dart';

/// Ekranın arkasında yavaşça akan tek bir şarj kablosu.
/// Her kartta tekrarlanan fade-slide yerine, uygulamanın ortak motifi.
class HarborFrame extends StatelessWidget {
  final Widget child;

  const HarborFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const Positioned.fill(child: HarborAtmosphere()),
        Positioned.fill(child: child),
      ],
    );
  }
}

class HarborAtmosphere extends StatefulWidget {
  final bool forceDark;

  const HarborAtmosphere({super.key, this.forceDark = false});

  @override
  State<HarborAtmosphere> createState() => _HarborAtmosphereState();
}

class _HarborAtmosphereState extends State<HarborAtmosphere> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 14),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = MediaQuery.disableAnimationsOf(context);
    if (reduce) {
      _controller.value = 0.35;
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = widget.forceDark || context.colors.isDark;
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _CablePainter(t: _controller.value, dark: dark),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}

class _CablePainter extends CustomPainter {
  final double t;
  final bool dark;

  _CablePainter({required this.t, required this.dark});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = dark ? AppPalette.night : AppPalette.foam,
    );

    final wash = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.8, -0.9),
        radius: 1.1,
        colors: [
          (dark ? AppPalette.sea : AppPalette.seaGlass).withValues(alpha: dark ? 0.22 : 0.28),
          Colors.transparent,
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, wash);

    _cable(
      canvas,
      size,
      y0: 0.16,
      y1: 0.08,
      y2: 0.34,
      y3: 0.2,
      alpha: dark ? 0.55 : 0.4,
      width: 2.2,
    );
    _cable(
      canvas,
      size,
      y0: 0.78,
      y1: 0.62,
      y2: 0.9,
      y3: 0.7,
      alpha: dark ? 0.28 : 0.22,
      width: 1.4,
    );
  }

  void _cable(
    Canvas canvas,
    Size size, {
    required double y0,
    required double y1,
    required double y2,
    required double y3,
    required double alpha,
    required double width,
  }) {
    final path = Path()
      ..moveTo(-size.width * 0.05, size.height * y0)
      ..cubicTo(
        size.width * 0.28,
        size.height * y1,
        size.width * 0.62,
        size.height * y2,
        size.width * 1.08,
        size.height * y3,
      );

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round
        ..color = (dark ? AppPalette.seaGlass : AppPalette.sea).withValues(alpha: alpha * 0.45),
    );

    for (final metric in path.computeMetrics()) {
      final length = metric.length;
      final span = length * 0.18;
      final start = (t * length) % length;
      final end = start + span;
      if (end <= length) {
        canvas.drawPath(metric.extractPath(start, end), _spark(width, alpha));
      } else {
        canvas.drawPath(metric.extractPath(start, length), _spark(width, alpha));
        canvas.drawPath(metric.extractPath(0, end - length), _spark(width, alpha));
      }
    }
  }

  Paint _spark(double width, double alpha) {
    return Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width + 1.2
      ..strokeCap = StrokeCap.round
      ..color = AppPalette.sodium.withValues(alpha: alpha);
  }

  @override
  bool shouldRepaint(_CablePainter oldDelegate) => oldDelegate.t != t || oldDelegate.dark != dark;
}
