import 'package:flutter/material.dart';
import 'package:mobile_zpi/features/routine/data/models/routine_task.dart';
import 'package:mobile_zpi/features/routine/data/models/task_occurrence.dart';
import 'package:mobile_zpi/features/routine/presentation/routine_labels.dart';
import 'package:mobile_zpi/features/routine/presentation/widgets/routine_occurrence_tile.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_icon_circle.dart';

class RoutineTaskCard extends StatelessWidget {
  const RoutineTaskCard({
    super.key,
    required this.seniorId,
    required this.task,
    required this.occurrences,
    required this.submittingId,
    required this.canDecide,
    required this.onTap,
  });

  final String seniorId;
  final RoutineTask task;
  final List<TaskOccurrence> occurrences;
  final String? submittingId;
  final bool canDecide;
  final VoidCallback onTap;

  static const double _chevronSize = 28;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final secondaryStyle = AppTypography.bodyMedium.copyWith(
      color: colors.onSurface,
    );

    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: AppRadius.lgAll,
        boxShadow: AppShadows.sm,
      ),
      child: Material(
        color: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgAll,
          side: colors.isHighContrast
              ? BorderSide(color: colors.outline, width: 2)
              : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              button: true,
              child: InkWell(
                onTap: onTap,
                highlightColor: colors.surfacePressed,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      ExcludeSemantics(
                        child: AppIconCircle.small(
                          icon: routineTypeIcon(task.type),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: AppSpacing.xs,
                          children: [
                            Text(
                              task.title,
                              style: AppTypography.titleLarge.copyWith(
                                color: colors.onBackground,
                              ),
                            ),
                            Text(
                              routineTypeLabel(task.type),
                              style: secondaryStyle,
                            ),
                            if (occurrences.isEmpty)
                              Text(
                                formatSchedule(task.schedule),
                                style: secondaryStyle,
                              ),
                            if (!task.isActive)
                              Text(
                                'Nieaktywne',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: colors.error,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Icon(
                        Icons.chevron_right,
                        size: _chevronSize,
                        color: colors.onSurface,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (occurrences.isNotEmpty) ...[
              Divider(height: 1, thickness: 1, color: colors.outline),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: AppSpacing.sm,
                  children: [
                    for (final occurrence in occurrences)
                      RoutineOccurrenceTile(
                        seniorId: seniorId,
                        occurrence: occurrence,
                        submittingId: submittingId,
                        canDecide: canDecide,
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
