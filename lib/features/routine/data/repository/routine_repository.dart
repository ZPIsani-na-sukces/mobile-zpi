import 'package:mobile_zpi/config/app_env.dart';
import 'package:mobile_zpi/features/routine/data/repository/api_routine_repository.dart';
import 'package:mobile_zpi/features/routine/data/routine_task_draft.dart';
import 'package:mobile_zpi/network/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routine_repository.g.dart';

abstract interface class RoutineRepository {
  Future<void> createTask(String seniorId, RoutineTaskDraft draft);
}

@Riverpod(keepAlive: true)
RoutineRepository routineRepository(Ref ref) {
  if (AppEnv.useMocks) return MockRoutineRepository();
  return ApiRoutineRepository(ref.watch(authDioProvider));
}
