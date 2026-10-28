import 'package:latlong2/latlong.dart';
import 'package:mobile_zpi/features/geozones/controllers/current_location_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/walking_route_controller.dart';
import 'package:mobile_zpi/features/geozones/data/models/walking_route.dart';
import 'package:mobile_zpi/features/geozones/utils/route_geometry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'walking_route_progress_controller.g.dart';

@riverpod
WalkingRouteProgress? walkingRouteProgress(Ref ref) {
  final route = ref.watch(walkingRouteControllerProvider).value;
  if (route == null || route.points.isEmpty) return null;

  final position = ref.watch(currentLocationControllerProvider).value;
  final projection = position == null
      ? null
      : projectOntoRoute(position.latLng, route.points);
  if (projection == null) {
    return WalkingRouteProgress(
      remainingMeters: route.distanceMeters,
      remainingSeconds: route.durationSeconds,
    );
  }

  const distance = Distance();
  final points = route.points;
  final nextIndex = projection.segmentIndex + 1;
  var remainingMeters =
      projection.distanceMeters + distance(projection.point, points[nextIndex]);
  for (var i = nextIndex; i < points.length - 1; i++) {
    remainingMeters += distance(points[i], points[i + 1]);
  }

  final secondsPerMeter = route.distanceMeters > 0
      ? route.durationSeconds / route.distanceMeters
      : 0.0;
  return WalkingRouteProgress(
    remainingMeters: remainingMeters,
    remainingSeconds: remainingMeters * secondsPerMeter,
  );
}
