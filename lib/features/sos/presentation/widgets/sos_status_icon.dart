import 'package:flutter/material.dart';

class SosStatusIcon extends StatelessWidget {
  const SosStatusIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.onColor,
    this.busy = false,
  });

  final IconData icon;
  final Color color;
  final Color onColor;
  final bool busy;

  static const double _busyCircleSize = 120;
  static const double _doneCircleSize = 88;
  static const double _ringSize = 144;
  static const double _ringWidth = 6;
  static const double _busyIconSize = 64;
  static const double _doneIconSize = 52;

  @override
  Widget build(BuildContext context) {
    final circleSize = busy ? _busyCircleSize : _doneCircleSize;

    return SizedBox.square(
      dimension: busy ? _ringSize : circleSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (busy)
            SizedBox.square(
              dimension: _ringSize,
              child: CircularProgressIndicator(
                strokeWidth: _ringWidth,
                color: color,
              ),
            ),
          Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(
              icon,
              size: busy ? _busyIconSize : _doneIconSize,
              color: onColor,
            ),
          ),
        ],
      ),
    );
  }
}
