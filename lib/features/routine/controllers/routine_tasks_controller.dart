import 'package:mobile_zpi/features/routine/data/models/routine_task.dart';
import 'package:mobile_zpi/features/routine/data/repository/routine_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routine_tasks_controller.g.dart';

@riverpod
class RoutineTasksController extends _$RoutineTasksController {
  @override
  Future<List<RoutineTask>> build(String seniorId) =>
      ref.watch(routineRepositoryProvider).tasks(seniorId);
}
