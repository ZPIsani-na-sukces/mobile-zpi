import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/routine/controllers/task_confirmation_controller.dart';
import 'package:mobile_zpi/features/routine/data/models/task_occurrence.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';
import 'package:mobile_zpi/widgets/back_scaffold.dart';

@RoutePage()
class TaskSliderView extends ConsumerWidget {
  const TaskSliderView({super.key, required this.seniorId});

  final String seniorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final confirmation = ref.watch(
      taskConfirmationControllerProvider(seniorId),
    );

    return BackScaffold(
      title: 'Potwierdzenie',
      body: confirmation.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) =>
            const Center(child: Text('Nie udało się wczytać zadań.')),
        data: (state) {
          if (state.items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  'Wszystkie zadania na dziś są potwierdzone.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.onBackground,
                  ),
                ),
              ),
            );
          }

          final task = state.items.first;
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${state.items.length} do potwierdzenia',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _Card(task: task),
                if (state.error != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    state.error!,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ],
                const Spacer(),
                AppButton.primary(
                  label: 'Potwierdź',
                  onPressed: state.submitting
                      ? null
                      : () => ref
                            .read(
                              taskConfirmationControllerProvider(seniorId)
                                  .notifier,
                            )
                            .decide(task.occurrenceId, 'confirmed'),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton.secondary(
                  label: 'Pomiń',
                  onPressed: state.submitting
                      ? null
                      : () => ref
                            .read(
                              taskConfirmationControllerProvider(seniorId)
                                  .notifier,
                            )
                            .decide(task.occurrenceId, 'skipped'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.task});

  final TaskOccurrence task;

  @override
  Widget build(BuildContext context) {
    final local = task.scheduledAt.toLocal();
    final time =
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        boxShadow: AppShadows.sm,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _typeLabel(task.type),
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              task.title,
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.onBackground,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              time,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              task.instructions,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.onBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _typeLabel(String type) {
  return switch (type) {
    'medication' => 'Lek',
    'meal' => 'Posiłek',
    'hydration' => 'Nawodnienie',
    _ => type,
  };
}
