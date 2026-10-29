import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';

class HomeMarker extends StatelessWidget {
  const HomeMarker({super.key});

  static const double size = 40;
  static const double _borderWidth = 3;
  static const double _iconSize = 22;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.primary,
        shape: BoxShape.circle,
        border: Border.all(color: context.colors.surface, width: _borderWidth),
        boxShadow: AppShadows.md,
      ),
      child: Icon(
        Icons.home_rounded,
        color: context.colors.onPrimary,
        size: _iconSize,
      ),
    );
  }
}
