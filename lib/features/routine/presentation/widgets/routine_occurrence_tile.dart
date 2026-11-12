import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/routine/controllers/task_confirmation_controller.dart';
import 'package:mobile_zpi/features/routine/data/models/task_occurrence.dart';
import 'package:mobile_zpi/features/routine/presentation/routine_labels.dart';
import 'package:mobile_zpi/features/routine/presentation/widgets/routine_occurrence_status.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';

class RoutineOccurrenceTile extends ConsumerWidget {
  const RoutineOccurrenceTile({
    super.key,
    required this.seniorId,
    required this.occurrence,
    required this.submittingId,
    required this.canDecide,
  });

  final String seniorId;
  final TaskOccurrence occurrence;
  final String? submittingId;
  final bool canDecide;

  static const double _progressSize = 24;
  static const double _maxRowTextScale = 1.3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final open =
        occurrence.status == 'pending' || occurrence.status == 'missed';
    if (!canDecide || !open) {
      return RoutineOccurrenceStatus(occurrence: occurrence);
    }

    final colors = context.colors;
    final locked = submittingId != null;
    final busy = submittingId == occurrence.occurrenceId;
    final time = formatClock(occurrence.scheduledAt);

    void decide(String decision) => ref
        .read(taskConfirmationControllerProvider(seniorId).notifier)
        .decide(occurrence.occurrenceId, decision);

    Future<void> onSkip() async {
      final confirmed = await _confirmSkip(context, time);
      if (confirmed == true) decide('skipped');
    }

    final confirmButton = AppButton.primary(
      label: 'Zrobione',
      icon: Icons.check,
      onPressed: locked ? null : () => decide('confirmed'),
    );
    final skipButton = AppButton.secondary(
      label: 'Pomiń',
      onPressed: locked ? null : onSkip,
    );
    final labelSize = AppTypography.labelLarge.fontSize!;
    final stacked =
        MediaQuery.textScalerOf(context).scale(labelSize) >
        labelSize * _maxRowTextScale;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: AppRadius.mdAll,
        border: Border.all(
          color: colors.outline,
          width: colors.isHighContrast ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    time,
                    style: AppTypography.titleLarge.copyWith(
                      color: colors.primary,
                      fontFeatures: const [
                        ...AppTypography.fontFeatures,
                        FontFeature.tabularFigures(),
                      ],
                    ),
                  ),
                  if (occurrence.status == 'missed') ...[
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      occurrenceStatusLabel(occurrence.status),
                      style: AppTypography.labelLarge.copyWith(
                        color: colors.error,
                      ),
                    ),
                  ],
                ],
              ),
              if (busy)
                const Positioned(
                  right: 0,
                  child: SizedBox.square(
                    dimension: _progressSize,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (stacked) ...[
            confirmButton,
            const SizedBox(height: AppSpacing.md),
            skipButton,
          ] else
            Row(
              spacing: AppSpacing.md,
              children: [
                Expanded(child: skipButton),
                Expanded(flex: 2, child: confirmButton),
              ],
            ),
        ],
      ),
    );
  }

  Future<bool?> _confirmSkip(BuildContext context, String time) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: context.colors.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
        title: Text(
          'Pominąć zadanie?',
          style: AppTypography.headlineSmall.copyWith(
            color: context.colors.onBackground,
          ),
        ),
        content: Text(
          'Zadanie „${occurrence.title}” o $time zostanie oznaczone jako '
          'pominięte. Nie da się tego cofnąć.',
          style: AppTypography.bodyLarge.copyWith(
            color: context.colors.onSurface,
          ),
        ),
        actions: [
          AppButton.text(
            label: 'Anuluj',
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
          AppButton.primary(
            label: 'Pomiń',
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );
  }
}
