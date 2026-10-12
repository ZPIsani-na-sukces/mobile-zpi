import 'package:dio/dio.dart';
import 'package:mobile_zpi/features/routine/data/models/routine_task.dart';
import 'package:mobile_zpi/features/routine/data/models/task_occurrence.dart';
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

  @override
  Future<RoutineTask> task(String seniorId, String taskId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/seniors/$seniorId/routine-tasks/$taskId',
    );
    return RoutineTask.fromJson(response.data!);
  }

  @override
  Future<List<TaskOccurrence>> pendingToday(String seniorId) async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    final response = await _dio.get<Map<String, dynamic>>(
      '/seniors/$seniorId/task-occurrences',
      queryParameters: {
        'from': start.toUtc().toIso8601String(),
        'to': end.toUtc().toIso8601String(),
        'status': 'pending',
        'limit': 100,
      },
    );
    final items = response.data!['items'] as List<dynamic>;
    final occurrences =
        items
            .map(
              (item) => TaskOccurrence.fromJson(item as Map<String, dynamic>),
            )
            .toList()
          ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return occurrences;
  }

  @override
  Future<void> decide(
    String seniorId,
    String occurrenceId,
    String decision,
  ) async {
    await _dio.put<void>(
      '/seniors/$seniorId/task-occurrences/$occurrenceId/decision',
      data: {
        'decision': decision,
        'performedAt': DateTime.now().toUtc().toIso8601String(),
      },
    );
  }
}
