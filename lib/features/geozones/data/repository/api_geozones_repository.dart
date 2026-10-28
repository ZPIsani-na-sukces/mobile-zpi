import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_zpi/features/geozones/data/current_position.dart';
import 'package:mobile_zpi/features/geozones/data/models/geozone.dart';
import 'package:mobile_zpi/features/geozones/data/models/walking_route.dart';
import 'package:mobile_zpi/features/geozones/data/repository/geozones_repository.dart';
import 'package:mobile_zpi/features/geozones/data/walking_route_client.dart';

class ApiGeozonesRepository implements GeozonesRepository {
  ApiGeozonesRepository(this._dio, this._routingDio);

  final Dio _dio;
  final Dio _routingDio;

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

  @override
  Future<WalkingRoute> getWalkingRoute(
    LatLng destination, {
    LatLng? origin,
  }) async {
    final start = origin ?? await readCurrentPosition();
    return fetchWalkingRoute(_routingDio, start, destination);
  }
}
