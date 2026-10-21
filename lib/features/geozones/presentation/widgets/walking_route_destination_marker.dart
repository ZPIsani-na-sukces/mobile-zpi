import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';

class WalkingRouteDestinationMarker extends StatelessWidget {
  const WalkingRouteDestinationMarker({super.key});

  static const double size = 40;
  static const double _borderWidth = 3;
  static const double _iconSize = 22;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.surface, width: _borderWidth),
        boxShadow: AppShadows.md,
      ),
      child: const Icon(
        Icons.home_rounded,
        color: AppColors.onPrimary,
        size: _iconSize,
      ),
    );
  }
}
