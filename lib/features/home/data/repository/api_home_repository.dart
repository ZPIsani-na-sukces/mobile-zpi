import 'package:dio/dio.dart';
import 'package:mobile_zpi/features/home/data/models/home_overview.dart';
import 'package:mobile_zpi/features/home/data/repository/home_repository.dart';

class ApiHomeRepository implements HomeRepository {
  ApiHomeRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<HomeContact>> recentContacts(String seniorId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/seniors/$seniorId/contacts',
      queryParameters: {'isActive': true, 'sort': '-createdAt', 'limit': 4},
    );
    final items = response.data!['items'] as List<dynamic>;
    return items
        .map((item) => HomeContact.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<UpcomingTask>> upcomingTasks(String seniorId) async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    final response = await _dio.get<Map<String, dynamic>>(
      '/seniors/$seniorId/task-occurrences',
      queryParameters: {
        'from': start.toUtc().toIso8601String(),
        'to': end.toUtc().toIso8601String(),
        'status': 'pending',
        'limit': 4,
      },
    );
    final items = response.data!['items'] as List<dynamic>;
    final tasks =
        items
            .map((item) => UpcomingTask.fromJson(item as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return tasks;
  }

  @override
  Future<List<HomeZone>> geozones(String seniorId) async {
    final response = await _dio.get<List<dynamic>>(
      '/seniors/$seniorId/geozones',
      queryParameters: {'isActive': true},
    );
    return response.data!
        .map((item) => HomeZone.fromJson(item as Map<String, dynamic>))
        .where((zone) => zone.name.isNotEmpty)
        .toList();
  }
}
