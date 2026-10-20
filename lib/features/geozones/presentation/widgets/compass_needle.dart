import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';

class CompassNeedle extends StatelessWidget {
  const CompassNeedle({super.key, this.size = 24});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _CompassNeedlePainter(),
    );
  }
}

class _CompassNeedlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final halfWidth = size.width * 0.22;

    final north = Path()
      ..moveTo(center.dx, 0)
      ..lineTo(center.dx + halfWidth, center.dy)
      ..lineTo(center.dx - halfWidth, center.dy)
      ..close();

    final south = Path()
      ..moveTo(center.dx, size.height)
      ..lineTo(center.dx + halfWidth, center.dy)
      ..lineTo(center.dx - halfWidth, center.dy)
      ..close();

    canvas
      ..drawPath(north, Paint()..color = AppColors.error)
      ..drawPath(south, Paint()..color = AppColors.onDisabled);
  }

  @override
  bool shouldRepaint(covariant _CompassNeedlePainter oldDelegate) => false;
}
