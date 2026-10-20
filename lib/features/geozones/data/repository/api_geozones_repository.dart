import 'package:dio/dio.dart';
import 'package:mobile_zpi/features/geozones/data/models/geozone.dart';
import 'package:mobile_zpi/features/geozones/data/repository/geozones_repository.dart';

class ApiGeozonesRepository implements GeozonesRepository {
  ApiGeozonesRepository(this._dio);

  final Dio _dio;

  String _geozonesPath(String seniorId) => '/seniors/$seniorId/geozones';

  @override
  Future<List<Geozone>> getGeozones(String seniorId, {bool? isActive}) async {
    final response = await _dio.get<List<dynamic>>(
      _geozonesPath(seniorId),
      queryParameters: {'isActive': ?isActive},
    );
    return response.data!
        .map((e) => Geozone.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
