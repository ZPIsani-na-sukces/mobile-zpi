import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/routine/controllers/routine_tasks_controller.dart';
import 'package:mobile_zpi/features/routine/presentation/routine_labels.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/back_scaffold.dart';

@RoutePage()
class RoutineTaskView extends ConsumerWidget {
  const RoutineTaskView({
    super.key,
    required this.seniorId,
    required this.taskId,
  });

  final String seniorId;
  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(routineTaskControllerProvider(seniorId, taskId));

    return BackScaffold(
      title: 'Zadanie',
      body: task.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) =>
            const Center(child: Text('Nie udało się wczytać zadania.')),
        data: (value) => ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              routineTypeLabel(value.type),
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value.title,
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.onBackground,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              value.instructions,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.onBackground,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _Row(label: 'Kiedy', value: formatSchedule(value.schedule)),
            _Row(label: 'Od', value: value.startsOn),
            _Row(label: 'Do', value: value.endsOn ?? 'Bez daty końca'),
            _Row(
              label: 'Status',
              value: value.isActive ? 'Aktywne' : 'Nieaktywne',
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.onBackground,
            ),
          ),
        ],
      ),
    );
  }
}
