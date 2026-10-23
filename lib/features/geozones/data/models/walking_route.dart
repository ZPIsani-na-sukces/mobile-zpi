import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'walking_route.freezed.dart';

@freezed
abstract class WalkingRoute with _$WalkingRoute {
  const factory WalkingRoute({
    required List<LatLng> points,
    required double distanceMeters,
    required double durationSeconds,
  }) = _WalkingRoute;
}

@freezed
abstract class WalkingRouteProgress with _$WalkingRouteProgress {
  const factory WalkingRouteProgress({
    required double remainingMeters,
    required double remainingSeconds,
  }) = _WalkingRouteProgress;
}

class RouteNotFoundException implements Exception {
  const RouteNotFoundException();
}
