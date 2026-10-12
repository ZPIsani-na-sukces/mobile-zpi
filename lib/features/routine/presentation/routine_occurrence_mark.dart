import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/routine/controllers/task_confirmation_controller.dart';
import 'package:mobile_zpi/features/routine/data/models/task_occurrence.dart';
import 'package:mobile_zpi/features/routine/presentation/routine_labels.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';

class RoutineOccurrenceMark extends ConsumerWidget {
  const RoutineOccurrenceMark({
    super.key,
    required this.seniorId,
    required this.occurrence,
    required this.submittingId,
  });

  final String seniorId;
  final TaskOccurrence occurrence;
  final String? submittingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = occurrence.status == 'pending';
    final busy = submittingId == occurrence.occurrenceId;
    final status = occurrenceStatusLabel(occurrence.status);
    final time = formatClock(occurrence.scheduledAt);

    return Row(
      children: [
        Checkbox(
          value: occurrence.status == 'confirmed',
          checkColor: AppColors.onSuccess,
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.success;
            }
            return AppColors.surface;
          }),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          side: const BorderSide(color: AppColors.primary, width: 2),
          onChanged: (checked) {
            if (busy) return;
            ref
                .read(taskConfirmationControllerProvider(seniorId).notifier)
                .decide(
                  occurrence.occurrenceId,
                  checked == true ? 'confirmed' : 'pending',
                );
          },
        ),
        Expanded(
          child: Text(
            status.isEmpty ? time : '$time · $status',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.onBackground,
            ),
          ),
        ),
        if (pending)
          AppButton.text(
            label: 'Pomiń',
            onPressed: busy
                ? null
                : () => ref
                      .read(
                        taskConfirmationControllerProvider(seniorId).notifier,
                      )
                      .decide(occurrence.occurrenceId, 'skipped'),
          ),
      ],
    );
  }
}
