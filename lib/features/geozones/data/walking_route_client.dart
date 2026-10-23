import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_zpi/features/geozones/data/models/walking_route.dart';

String _routePath(LatLng from, LatLng to) =>
    '/route/v1/foot/${from.longitude},${from.latitude};'
    '${to.longitude},${to.latitude}';

Future<WalkingRoute> fetchWalkingRoute(
  Dio routingDio,
  LatLng origin,
  LatLng destination,
) async {
  final response = await routingDio.get<Map<String, dynamic>>(
    _routePath(origin, destination),
    queryParameters: {'overview': 'full', 'geometries': 'geojson'},
  );

  final data = response.data!;
  final routes = data['routes'] as List<dynamic>?;
  if (data['code'] != 'Ok' || routes == null || routes.isEmpty) {
    throw const RouteNotFoundException();
  }

  final route = routes.first as Map<String, dynamic>;
  final coordinates =
      (route['geometry'] as Map<String, dynamic>)['coordinates']
          as List<dynamic>;

  return WalkingRoute(
    points: coordinates.map((e) {
      final point = e as List<dynamic>;
      return LatLng((point[1] as num).toDouble(), (point[0] as num).toDouble());
    }).toList(),
    distanceMeters: (route['distance'] as num).toDouble(),
    durationSeconds: (route['duration'] as num).toDouble(),
  );
}
