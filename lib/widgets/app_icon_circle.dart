import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';

class AppIconCircle extends StatelessWidget {
  const AppIconCircle({super.key, required this.icon});

  final IconData icon;

  static const double _size = 120;
  static const double _iconSize = 64;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        color: context.colors.primary.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: _iconSize, color: context.colors.primary),
    );
  }
}
