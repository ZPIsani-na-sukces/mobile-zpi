import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
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
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.colors.error.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: AppShadows.lg,
          ),
          child: Material(
            color: context.colors.error,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              child: SizedBox.square(
                dimension: _size,
                child: Center(
                  child: ExcludeSemantics(
                    child: Text(
                      'SOS',
                      style: AppTypography.displaySmall.copyWith(
                        color: context.colors.onError,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
