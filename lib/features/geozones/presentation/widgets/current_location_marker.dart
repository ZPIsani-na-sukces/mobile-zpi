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
        color: context.colors.primary,
        shape: BoxShape.circle,
        border: Border.all(color: context.colors.surface, width: 3),
        boxShadow: AppShadows.md,
      ),
      child: showDirection
          ? Icon(
              Icons.navigation,
              color: context.colors.onPrimary,
              size: _directionIconSize,
            )
          : null,
    );
  }
}
