import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/profile/controllers/profile_controller.dart';
import 'package:mobile_zpi/features/routine/controllers/routine_tasks_controller.dart';
import 'package:mobile_zpi/features/routine/controllers/task_confirmation_controller.dart';
import 'package:mobile_zpi/features/routine/data/models/routine_task.dart';
import 'package:mobile_zpi/features/routine/data/task_confirmation_state.dart';
import 'package:mobile_zpi/features/routine/presentation/widgets/routine_task_card.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
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
        body: _TaskList(
          seniorId: account.userId,
          canDecide: account.role == 'senior',
        ),
      ),
      AsyncError() => AppNoConnectionInfo(
        onRetry: () => ref.invalidate(profileControllerProvider),
      ),
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _TaskList extends ConsumerWidget {
  const _TaskList({required this.seniorId, required this.canDecide});

  final String seniorId;
  final bool canDecide;

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
        return RoutineTaskCard(
          seniorId: seniorId,
          task: task,
          occurrences: [
            for (final item in occurrences)
              if (item.taskId == task.taskId) item,
          ],
          submittingId: submittingId,
          canDecide: canDecide,
          onTap: () => context.router.push(
            RoutineTaskRoute(seniorId: seniorId, taskId: task.taskId),
          ),
        );
      },
    );
  }
}
