import 'dart:math' as math;

import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_zpi/features/geozones/controllers/current_location_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/route_navigation_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/walking_route_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'route_arrival_controller.g.dart';

@riverpod
class RouteArrivalController extends _$RouteArrivalController {
  static const double arrivalRadiusMeters = 25;
  static const double _maxAccuracyMeters = 50;

  @override
  bool build() {
    if (!ref.watch(routeNavigationControllerProvider)) return false;

    ref.listen(currentLocationControllerProvider, (_, next) {
      if (next case AsyncData(:final value)) _onPosition(value);
    });
    return false;
  }

  void _onPosition(LocationMarkerPosition position) {
    final route = ref.read(walkingRouteControllerProvider).value;
    if (route == null || state) return;
    if (position.accuracy > _maxAccuracyMeters) return;

    const distance = Distance();
    final toDestination = distance(position.latLng, route.destination);
    final toRouteEnd = route.points.isEmpty
        ? toDestination
        : distance(position.latLng, route.points.last);
    if (math.min(toDestination, toRouteEnd) < arrivalRadiusMeters) {
      state = true;
    }
  }
}
