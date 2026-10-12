import 'package:mobile_zpi/features/routine/data/repository/routine_repository.dart';
import 'package:mobile_zpi/features/routine/data/routine_task_draft.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_routine_task_controller.g.dart';

@riverpod
class CreateRoutineTaskController extends _$CreateRoutineTaskController {
  @override
  FutureOr<void> build() {}

  Future<void> create(String seniorId, RoutineTaskDraft draft) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(routineRepositoryProvider).createTask(seniorId, draft),
    );
  }
}
