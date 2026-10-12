import 'package:dio/dio.dart';
import 'package:mobile_zpi/features/routine/data/models/routine_task.dart';
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

  @override
  Future<List<RoutineTask>> tasks(String seniorId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/seniors/$seniorId/routine-tasks',
      queryParameters: {'limit': 100},
    );
    final items = response.data!['items'] as List<dynamic>;
    return items
        .map((item) => RoutineTask.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
