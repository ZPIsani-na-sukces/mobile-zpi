import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';

class CompassNeedle extends StatelessWidget {
  const CompassNeedle({super.key, this.size = 24});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _CompassNeedlePainter(
        north: context.colors.error,
        south: context.colors.onDisabled,
      ),
    );
  }
}

class _CompassNeedlePainter extends CustomPainter {
  const _CompassNeedlePainter({required this.north, required this.south});

  final Color north;
  final Color south;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final halfWidth = size.width * 0.22;

    final northPath = Path()
      ..moveTo(center.dx, 0)
      ..lineTo(center.dx + halfWidth, center.dy)
      ..lineTo(center.dx - halfWidth, center.dy)
      ..close();

    final southPath = Path()
      ..moveTo(center.dx, size.height)
      ..lineTo(center.dx + halfWidth, center.dy)
      ..lineTo(center.dx - halfWidth, center.dy)
      ..close();

    canvas
      ..drawPath(northPath, Paint()..color = north)
      ..drawPath(southPath, Paint()..color = south);
  }

  @override
  bool shouldRepaint(covariant _CompassNeedlePainter oldDelegate) =>
      oldDelegate.north != north || oldDelegate.south != south;
}
