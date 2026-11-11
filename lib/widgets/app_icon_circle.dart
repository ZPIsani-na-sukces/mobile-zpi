import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';

class AppIconCircle extends StatelessWidget {
  const AppIconCircle({super.key, required this.icon})
    : size = 120,
      iconSize = 64;

  const AppIconCircle.small({super.key, required this.icon})
    : size = smallSize,
      iconSize = 28;

  static const double smallSize = 56;

  final IconData icon;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.colors.primary.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: iconSize, color: context.colors.primary),
    );
  }
}
