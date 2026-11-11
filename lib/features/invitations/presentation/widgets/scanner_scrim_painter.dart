import 'package:flutter/material.dart';

class ScannerScrimPainter extends CustomPainter {
  const ScannerScrimPainter({
    required this.color,
    required this.window,
    required this.radius,
  });

  final Color color;
  final Rect window;
  final Radius radius;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addRRect(RRect.fromRectAndRadius(window, radius));
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(ScannerScrimPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.window != window ||
      oldDelegate.radius != radius;
}
