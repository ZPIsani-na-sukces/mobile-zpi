import 'dart:math' as math;

import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_zpi/features/geozones/controllers/current_location_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/route_arrival_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/route_navigation_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/walking_route_controller.dart';
import 'package:mobile_zpi/features/geozones/utils/route_geometry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'route_reroute_controller.g.dart';

@riverpod
class RouteRerouteController extends _$RouteRerouteController {
  static const double _maxAccuracyMeters = 50;
  static const double _minOffRouteMeters = 30;
  static const int _requiredOffRouteReadings = 2;
  static const Duration _cooldown = Duration(seconds: 20);

  var _offRouteReadings = 0;
  DateTime? _lastRerouteAt;

  @override
  bool build() {
    _offRouteReadings = 0;
    _lastRerouteAt = null;
    if (!ref.watch(routeNavigationControllerProvider)) return false;

    ref.listen(currentLocationControllerProvider, (_, next) {
      if (next case AsyncData(:final value)) _onPosition(value);
    });
    return false;
  }

  void _onPosition(LocationMarkerPosition position) {
    final route = ref.read(walkingRouteControllerProvider).value;
    if (route == null || state) return;

    final accuracy = position.accuracy.isNaN ? 0.0 : position.accuracy;
    if (accuracy > _maxAccuracyMeters) return;

    const distance = Distance();
    final toDestination = distance(position.latLng, route.destination);
    if (toDestination < RouteArrivalController.arrivalRadiusMeters) return;

    final projection = projectOntoRoute(position.latLng, route.points);
    if (projection == null) return;
    if (projection.distanceMeters <= math.max(_minOffRouteMeters, accuracy)) {
      _offRouteReadings = 0;
      return;
    }

    _offRouteReadings++;
    if (_offRouteReadings < _requiredOffRouteReadings) return;

    final lastRerouteAt = _lastRerouteAt;
    final isCoolingDown =
        lastRerouteAt != null &&
        DateTime.now().difference(lastRerouteAt) < _cooldown;
    if (isCoolingDown) return;

    _reroute(position.latLng);
  }

  Future<void> _reroute(LatLng origin) async {
    _offRouteReadings = 0;
    _lastRerouteAt = DateTime.now();
    state = true;
    await ref.read(walkingRouteControllerProvider.notifier).reroute(origin);
    if (ref.mounted) state = false;
  }
}
