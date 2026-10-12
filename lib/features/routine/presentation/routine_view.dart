import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/profile/controllers/profile_controller.dart';
import 'package:mobile_zpi/features/routine/controllers/routine_tasks_controller.dart';
import 'package:mobile_zpi/features/routine/data/models/routine_task.dart';
import 'package:mobile_zpi/features/routine/presentation/routine_labels.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';

@RoutePage()
class RoutineView extends ConsumerWidget {
  const RoutineView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);

    return profile.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) =>
          const Center(child: Text('Nie udało się wczytać profilu.')),
      data: (account) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              0,
            ),
            child: AppButton.primary(
              label: 'Nowe zadanie',
              onPressed: () => context.router.push(
                CreateRoutineTaskRoute(seniorId: account.userId),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              0,
            ),
            child: AppButton.secondary(
              label: 'Potwierdź zadania',
              onPressed: () => context.router.push(
                TaskSliderRoute(seniorId: account.userId),
              ),
            ),
          ),
          Expanded(child: _TaskList(seniorId: account.userId)),
        ],
      ),
    );
  }
}

class _TaskList extends ConsumerWidget {
  const _TaskList({required this.seniorId});

  final String seniorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(routineTasksControllerProvider(seniorId));

    return tasks.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => _Message(
        text: 'Nie udało się wczytać zadań.',
        actionLabel: 'Spróbuj ponownie',
        onPressed: () =>
            ref.invalidate(routineTasksControllerProvider(seniorId)),
      ),
      data: (items) {
        if (items.isEmpty) {
          return const _Message(text: 'Brak zadań.');
        }
        return ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final task = items[index];
            return _TaskCard(
              task: task,
              onTap: () => context.router.push(
                RoutineTaskRoute(seniorId: seniorId, taskId: task.taskId),
              ),
            );
          },
        );
      },
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.task, required this.onTap});

  final RoutineTask task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        boxShadow: AppShadows.sm,
      ),
      child: Material(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.lgAll,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  routineTypeLabel(task.type),
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  task.title,
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  formatSchedule(task.schedule),
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
                if (!task.isActive) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Nieaktywne',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, this.actionLabel, this.onPressed});

  final String text;
  final String? actionLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.onBackground,
            ),
          ),
          if (actionLabel != null && onPressed != null) ...[
            const SizedBox(height: AppSpacing.lg),
            AppButton.primary(label: actionLabel!, onPressed: onPressed),
          ],
        ],
      ),
    );
  }
}
