import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

class AppBadge extends StatelessWidget {
  const AppBadge({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  static const double _iconSize = 20;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.primary;

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: AppRadius.fullAll,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: Icon(icon, size: _iconSize, color: color),
              ),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text(
                  label,
                  style: AppTypography.labelLarge.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
