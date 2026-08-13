import 'package:flutter/material.dart';

/// Gerçek harita SDK'sı bağlanana kadar kullanılan, hafif "harita hissi"
/// veren dekoratif arkaplan. Sokak dokusunu andıran ince bir ızgara çizer.
class MapGridBackground extends StatelessWidget {
  final Color baseColor;
  final Color lineColor;

  const MapGridBackground({super.key, required this.baseColor, required this.lineColor});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GridPainter(baseColor: baseColor, lineColor: lineColor),
      size: Size.infinite,
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color baseColor;
  final Color lineColor;

  _GridPainter({required this.baseColor, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = baseColor);

    final thin = Paint()
      ..color = lineColor.withValues(alpha: 0.35)
      ..strokeWidth = 1;
    final thick = Paint()
      ..color = lineColor.withValues(alpha: 0.55)
      ..strokeWidth = 1.4;

    const step = 28.0;
    for (double x = 0; x < size.width; x += step) {
      final isMajor = (x / step).round() % 4 == 0;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), isMajor ? thick : thin);
    }
    for (double y = 0; y < size.height; y += step) {
      final isMajor = (y / step).round() % 4 == 0;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), isMajor ? thick : thin);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) =>
      oldDelegate.baseColor != baseColor || oldDelegate.lineColor != lineColor;
}
