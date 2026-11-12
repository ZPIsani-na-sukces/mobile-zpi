import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/profile/controllers/profile_controller.dart';
import 'package:mobile_zpi/features/routine/controllers/routine_tasks_controller.dart';
import 'package:mobile_zpi/features/routine/presentation/routine_labels.dart';
import 'package:mobile_zpi/features/routine/presentation/widgets/routine_inactive_banner.dart';
import 'package:mobile_zpi/features/routine/presentation/widgets/routine_instruction_card.dart';
import 'package:mobile_zpi/features/routine/presentation/widgets/routine_today_card.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_badge.dart';
import 'package:mobile_zpi/widgets/app_detail_row.dart';
import 'package:mobile_zpi/widgets/app_details_card.dart';
import 'package:mobile_zpi/widgets/app_no_connection_info.dart';
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
    final canDecide =
        ref.watch(profileControllerProvider).value?.role == 'senior';

    return BackScaffold(
      title: 'Zadanie',
      body: switch (task) {
        AsyncData(:final value) => ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            if (!value.isActive) ...[
              const RoutineInactiveBanner(),
              const SizedBox(height: AppSpacing.lg),
            ],
            AppBadge(
              icon: routineTypeIcon(value.type),
              label: routineTypeLabel(value.type),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              value.title,
              style: AppTypography.headlineSmall.copyWith(
                color: context.colors.onBackground,
              ),
            ),
            if (value.instructions.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              RoutineInstructionCard(instructions: value.instructions),
            ],
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Dziś',
              style: AppTypography.titleLarge.copyWith(
                color: context.colors.onBackground,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            RoutineTodayCard(
              seniorId: seniorId,
              taskId: value.taskId,
              canDecide: canDecide,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppDetailsCard(
              rows: [
                AppDetailRow(
                  icon: Icons.event_repeat,
                  label: 'Dni',
                  value: formatDays(value.schedule.daysOfWeek),
                ),
                AppDetailRow(
                  icon: Icons.schedule,
                  label: value.schedule.times.length == 1
                      ? 'Godzina'
                      : 'Godziny',
                  value: formatTimes(value.schedule.times),
                ),
                AppDetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Obowiązuje',
                  value: formatValidity(value.startsOn, value.endsOn),
                ),
              ],
            ),
          ],
        ),
        AsyncError() => AppNoConnectionInfo(
          onRetry: () =>
              ref.invalidate(routineTaskControllerProvider(seniorId, taskId)),
        ),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
