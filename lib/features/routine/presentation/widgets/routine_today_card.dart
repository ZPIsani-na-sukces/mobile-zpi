import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/routine/controllers/task_confirmation_controller.dart';
import 'package:mobile_zpi/features/routine/data/task_confirmation_state.dart';
import 'package:mobile_zpi/features/routine/presentation/widgets/routine_occurrence_tile.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_card.dart';

class RoutineTodayCard extends ConsumerWidget {
  const RoutineTodayCard({
    super.key,
    required this.seniorId,
    required this.taskId,
    required this.canDecide,
  });

  final String seniorId;
  final String taskId;
  final bool canDecide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final confirmation = ref.watch(
      taskConfirmationControllerProvider(seniorId),
    );

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: switch (confirmation) {
        AsyncData(:final value) => _content(context, value),
        AsyncError() => _message(
          'Nie udało się wczytać dzisiejszych zadań.',
          context.colors.onBackground,
        ),
        AsyncLoading() => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Center(child: CircularProgressIndicator()),
        ),
      },
    );
  }

  Widget _content(BuildContext context, TaskConfirmationState state) {
    final items = [
      for (final item in state.items)
        if (item.taskId == taskId) item,
    ];
    if (items.isEmpty) {
      return _message('Dziś nie ma tego zadania.', context.colors.onBackground);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        if (state.error case final error?)
          _message(error, context.colors.error),
        for (final item in items)
          RoutineOccurrenceTile(
            seniorId: seniorId,
            occurrence: item,
            submittingId: state.submittingId,
            canDecide: canDecide,
          ),
      ],
    );
  }

  Widget _message(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Text(text, style: AppTypography.bodyLarge.copyWith(color: color)),
    );
  }
}
