import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:mobile_zpi/features/geozones/controllers/current_location_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/route_navigation_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/route_reroute_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/walking_route_controller.dart';
import 'package:mobile_zpi/features/geozones/utils/route_geometry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'displayed_location_controller.g.dart';

@riverpod
LocationMarkerPosition? displayedLocation(Ref ref) {
  final position = ref.watch(currentLocationControllerProvider).value;

  if (position == null || !ref.watch(routeNavigationControllerProvider)) {
    return position;
  }

  final route = ref.watch(walkingRouteControllerProvider).value;
  final projection = route == null
      ? null
      : projectOntoRoute(position.latLng, route.points);
  if (projection == null ||
      projection.distanceMeters > RouteRerouteController.offRouteMeters) {
    return position;
  }

  return LocationMarkerPosition(
    latitude: projection.point.latitude,
    longitude: projection.point.longitude,
    accuracy: position.accuracy,
  );
}
