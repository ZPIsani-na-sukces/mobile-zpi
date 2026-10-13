import 'package:dio/dio.dart';
import 'package:mobile_zpi/features/routine/data/repository/routine_repository.dart';
import 'package:mobile_zpi/features/routine/data/task_confirmation_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_confirmation_controller.g.dart';

@riverpod
class TaskConfirmationController extends _$TaskConfirmationController {
  @override
  Future<TaskConfirmationState> build(String seniorId) async {
    final items = await ref
        .watch(routineRepositoryProvider)
        .occurrencesToday(seniorId);
    return TaskConfirmationState(items: items);
  }

  Future<void> decide(String occurrenceId, String decision) async {
    final current = state.value;
    if (current == null || current.submittingId != null) return;

    state = AsyncData(
      current.copyWith(submittingId: occurrenceId, error: null),
    );
    try {
      await ref
          .read(routineRepositoryProvider)
          .decide(seniorId, occurrenceId, decision);
      state = AsyncData(
        current.copyWith(
          submittingId: null,
          items: [
            for (final item in current.items)
              if (item.occurrenceId == occurrenceId)
                item.copyWith(status: decision)
              else
                item,
          ],
        ),
      );
    } on DioException catch (error) {
      final alreadyRecorded = error.response?.statusCode == 409;
      state = AsyncData(
        current.copyWith(
          submittingId: null,
          error: alreadyRecorded ? null : 'Nie udało się zapisać decyzji.',
          items: alreadyRecorded
              ? [
                  for (final item in current.items)
                    if (item.occurrenceId == occurrenceId)
                      item.copyWith(status: decision)
                    else
                      item,
                ]
              : current.items,
        ),
      );
    }
  }
}
