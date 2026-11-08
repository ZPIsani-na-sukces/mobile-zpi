import 'package:mobile_zpi/config/app_env.dart';
import 'package:mobile_zpi/features/routine/data/models/routine_task.dart';
import 'package:mobile_zpi/features/routine/data/models/task_occurrence.dart';
import 'package:mobile_zpi/features/routine/data/repository/api_routine_repository.dart';
import 'package:mobile_zpi/features/routine/data/repository/mock_routine_repository.dart';
import 'package:mobile_zpi/features/routine/data/routine_task_draft.dart';
import 'package:mobile_zpi/network/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routine_repository.g.dart';

abstract interface class RoutineRepository {
  Future<void> createTask(String seniorId, RoutineTaskDraft draft);

  Future<List<RoutineTask>> tasks(String seniorId);

  Future<RoutineTask> task(String seniorId, String taskId);

  Future<List<TaskOccurrence>> occurrencesToday(String seniorId);

  /// Pending occurrences in the next [days] days, for local reminders.
  Future<List<TaskOccurrence>> upcomingOccurrences(
    String seniorId, {
    int days = 7,
  });

  Future<void> decide(String seniorId, String occurrenceId, String decision);
}

@Riverpod(keepAlive: true)
RoutineRepository routineRepository(Ref ref) {
  if (AppEnv.useMocks) return MockRoutineRepository();
  return ApiRoutineRepository(ref.watch(authDioProvider));
}
