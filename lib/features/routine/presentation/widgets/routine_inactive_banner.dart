import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

class RoutineInactiveBanner extends StatelessWidget {
  const RoutineInactiveBanner({super.key});

  static const double _iconSize = 28;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.error.withValues(alpha: 0.08),
        borderRadius: AppRadius.lgAll,
        border: colors.isHighContrast
            ? Border.all(color: colors.error, width: 2)
            : null,
      ),
      child: Row(
        children: [
          ExcludeSemantics(
            child: Icon(
              Icons.pause_circle_outline,
              size: _iconSize,
              color: colors.error,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'To zadanie jest nieaktywne.',
              style: AppTypography.titleMedium.copyWith(color: colors.error),
            ),
          ),
        ],
      ),
    );
  }
}
