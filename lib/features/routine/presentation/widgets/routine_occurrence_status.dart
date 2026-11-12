import 'package:flutter/material.dart';
import 'package:mobile_zpi/features/routine/data/models/task_occurrence.dart';
import 'package:mobile_zpi/features/routine/presentation/routine_labels.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

class RoutineOccurrenceStatus extends StatelessWidget {
  const RoutineOccurrenceStatus({super.key, required this.occurrence});

  final TaskOccurrence occurrence;

  static const double _minHeight = 48;
  static const double _iconSize = 24;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (icon, color, background) = switch (occurrence.status) {
      'confirmed' => (
        Icons.check_circle,
        colors.success,
        colors.success.withValues(alpha: 0.12),
      ),
      'missed' => (
        Icons.error_outline,
        colors.error,
        colors.error.withValues(alpha: 0.08),
      ),
      'pending' => (
        Icons.schedule,
        colors.primary,
        colors.primary.withValues(alpha: 0.08),
      ),
      'cancelled' => (Icons.block, colors.onSurface, colors.background),
      _ => (Icons.remove_circle_outline, colors.onSurface, colors.background),
    };

    return MergeSemantics(
      child: Container(
        constraints: const BoxConstraints(minHeight: _minHeight),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: AppRadius.mdAll,
          border: colors.isHighContrast
              ? Border.all(color: color, width: 2)
              : null,
        ),
        child: Row(
          children: [
            Text(
              formatClock(occurrence.scheduledAt),
              style: AppTypography.titleMedium.copyWith(
                color: colors.onBackground,
                fontFeatures: const [
                  ...AppTypography.fontFeatures,
                  FontFeature.tabularFigures(),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Icon(icon, size: _iconSize, color: color),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                occurrenceStatusLabel(occurrence.status),
                style: AppTypography.labelLarge.copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
