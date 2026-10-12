import 'package:dio/dio.dart';
import 'package:mobile_zpi/features/routine/data/repository/routine_repository.dart';
import 'package:mobile_zpi/features/routine/data/routine_task_draft.dart';

class ApiRoutineRepository implements RoutineRepository {
  ApiRoutineRepository(this._dio);

  final Dio _dio;

  @override
  Future<void> createTask(String seniorId, RoutineTaskDraft draft) {
    return _dio.post<void>(
      '/seniors/$seniorId/routine-tasks',
      data: draft.toJson(),
    );
  }
}

class MockRoutineRepository implements RoutineRepository {
  @override
  Future<void> createTask(String seniorId, RoutineTaskDraft draft) async {}
}
