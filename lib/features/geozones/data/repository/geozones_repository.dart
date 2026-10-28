import 'package:latlong2/latlong.dart';
import 'package:mobile_zpi/config/app_env.dart';
import 'package:mobile_zpi/features/geozones/data/models/geozone.dart';
import 'package:mobile_zpi/features/geozones/data/models/walking_route.dart';
import 'package:mobile_zpi/features/geozones/data/repository/api_geozones_repository.dart';
import 'package:mobile_zpi/features/geozones/data/repository/mock_geozones_repository.dart';
import 'package:mobile_zpi/network/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'geozones_repository.g.dart';

abstract interface class GeozonesRepository {
  Future<List<Geozone>> getGeozones(String seniorId, {bool? isActive});

  Future<WalkingRoute> getWalkingRoute(LatLng destination, {LatLng? origin});
}

@Riverpod(keepAlive: true)
GeozonesRepository geozonesRepository(Ref ref) {
  final routingDio = ref.watch(routingDioProvider);
  if (AppEnv.useMocks) return MockGeozonesRepository(routingDio);
  return ApiGeozonesRepository(ref.watch(authDioProvider), routingDio);
}
