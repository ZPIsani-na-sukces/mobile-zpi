import 'package:flutter/material.dart';
import 'package:mobile_zpi/features/home/data/models/home_overview.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

class UpcomingTaskTile extends StatelessWidget {
  const UpcomingTaskTile({super.key, required this.task, required this.onTap});

  final UpcomingTask task;
  final VoidCallback onTap;

  static const double _chevronSize = 28;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final time = task.scheduledAt.toLocal();
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return Semantics(
      button: true,
      child: DecoratedBox(
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
          child: InkWell(
            onTap: onTap,
            highlightColor: colors.surfacePressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Text(
                    '$hour:$minute',
                    style: AppTypography.titleLarge.copyWith(
                      color: colors.primary,
                      fontFeatures: const [
                        ...AppTypography.fontFeatures,
                        FontFeature.tabularFigures(),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      task.title,
                      style: AppTypography.titleMedium.copyWith(
                        color: colors.onBackground,
                      ),
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
      ),
    );
  }
}
