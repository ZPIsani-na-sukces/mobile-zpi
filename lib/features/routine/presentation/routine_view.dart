import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/profile/controllers/profile_controller.dart';
import 'package:mobile_zpi/features/routine/controllers/routine_tasks_controller.dart';
import 'package:mobile_zpi/features/routine/controllers/task_confirmation_controller.dart';
import 'package:mobile_zpi/features/routine/data/models/routine_task.dart';
import 'package:mobile_zpi/features/routine/data/models/task_occurrence.dart';
import 'package:mobile_zpi/features/routine/data/task_confirmation_state.dart';
import 'package:mobile_zpi/features/routine/presentation/routine_labels.dart';
import 'package:mobile_zpi/features/routine/presentation/routine_occurrence_mark.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_message.dart';
import 'package:mobile_zpi/widgets/app_no_connection_info.dart';

@RoutePage()
class RoutineView extends ConsumerWidget {
  const RoutineView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);

    return switch (profile) {
      AsyncData(value: final account) => Scaffold(
        backgroundColor: context.colors.background,
        // The API lets only a caregiver create tasks.
        floatingActionButton: account.role == 'senior'
            ? null
            : FloatingActionButton.extended(
                heroTag: 'new-routine-task',
                backgroundColor: context.colors.primary,
                foregroundColor: context.colors.onPrimary,
                icon: const Icon(Icons.add),
                label: Text(
                  'Nowe zadanie',
                  style: AppTypography.labelLarge.copyWith(
                    color: context.colors.onPrimary,
                  ),
                ),
                onPressed: () => context.router.push(
                  CreateRoutineTaskRoute(seniorId: account.userId),
                ),
              ),
        body: _TaskList(seniorId: account.userId),
      ),
      AsyncError() => AppNoConnectionInfo(
        onRetry: () => ref.invalidate(profileControllerProvider),
      ),
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _TaskList extends ConsumerWidget {
  const _TaskList({required this.seniorId});

  final String seniorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(routineTasksControllerProvider(seniorId));
    final confirmation = ref.watch(
      taskConfirmationControllerProvider(seniorId),
    );

    return switch (tasks) {
      AsyncData(value: final items) when items.isEmpty => const AppMessage(
        text: 'Brak zadań.',
      ),
      AsyncData(value: final items) => _list(context, items, confirmation),
      AsyncError() => AppNoConnectionInfo(
        onRetry: () => ref.invalidate(routineTasksControllerProvider(seniorId)),
      ),
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
    };
  }

  Widget _list(
    BuildContext context,
    List<RoutineTask> items,
    AsyncValue<TaskConfirmationState> confirmation,
  ) {
    final occurrences = confirmation.value?.items ?? const [];
    final submittingId = confirmation.value?.submittingId;
    final error = confirmation.hasError
        ? 'Nie udało się wczytać dzisiejszych zadań.'
        : confirmation.value?.error;

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        96,
      ),
      itemCount: items.length + (error == null ? 0 : 1),
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        if (error != null && index == 0) {
          return Text(
            error,
            style: AppTypography.bodyMedium.copyWith(
              color: context.colors.error,
            ),
          );
        }
        final task = items[error == null ? index : index - 1];
        return _TaskCard(
          seniorId: seniorId,
          task: task,
          occurrences: [
            for (final item in occurrences)
              if (item.taskId == task.taskId) item,
          ],
          submittingId: submittingId,
          onTap: () => context.router.push(
            RoutineTaskRoute(seniorId: seniorId, taskId: task.taskId),
          ),
        );
      },
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.seniorId,
    required this.task,
    required this.occurrences,
    required this.submittingId,
    required this.onTap,
  });

  final String seniorId;
  final RoutineTask task;
  final List<TaskOccurrence> occurrences;
  final String? submittingId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: context.colors.cardBorder,
        borderRadius: AppRadius.lgAll,
        boxShadow: AppShadows.sm,
      ),
      // Transparent, so the ink shows and the card outline stays visible.
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: onTap,
              borderRadius: occurrences.isEmpty
                  ? AppRadius.lgAll
                  : const BorderRadius.vertical(
                      top: Radius.circular(AppRadius.lg),
                    ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      routineTypeLabel(task.type),
                      style: AppTypography.labelLarge.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      task.title,
                      style: AppTypography.titleLarge.copyWith(
                        color: context.colors.onBackground,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      formatSchedule(task.schedule),
                      style: AppTypography.bodyLarge.copyWith(
                        color: context.colors.onSurface,
                      ),
                    ),
                    if (!task.isActive) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Nieaktywne',
                        style: AppTypography.bodyMedium.copyWith(
                          color: context.colors.error,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            for (final occurrence in occurrences)
              Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.sm,
                  right: AppSpacing.sm,
                  bottom: AppSpacing.xs,
                ),
                child: RoutineOccurrenceMark(
                  seniorId: seniorId,
                  occurrence: occurrence,
                  submittingId: submittingId,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
