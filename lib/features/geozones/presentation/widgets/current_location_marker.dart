import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';

class CurrentLocationMarker extends StatelessWidget {
  const CurrentLocationMarker({super.key, this.showDirection = false});

  final bool showDirection;

  static const double size = 32;
  static const double _directionIconSize = 18;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.surface, width: 3),
        boxShadow: AppShadows.md,
      ),
      child: showDirection
          ? const Icon(
              Icons.navigation,
              color: AppColors.onPrimary,
              size: _directionIconSize,
            )
          : null,
    );
  }
}
