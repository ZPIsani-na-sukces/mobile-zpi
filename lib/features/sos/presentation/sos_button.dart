import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

class SosButton extends StatelessWidget {
  const SosButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  static const double _size = 180;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'SOS, wezwij pomoc',
      child: Material(
        color: AppColors.error,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Ink(
            width: _size,
            height: _size,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.error,
              boxShadow: AppShadows.lg,
            ),
            child: Center(
              child: Text(
                'SOS',
                style: AppTypography.displaySmall.copyWith(
                  color: AppColors.onError,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
