import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';

class MapCircleButton extends StatelessWidget {
  const MapCircleButton({
    super.key,
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        boxShadow: AppShadows.md,
      ),
      child: IconButton(
        tooltip: tooltip,
        color: AppColors.onBackground,
        onPressed: onPressed,
        icon: icon,
      ),
    );
  }
}
