import 'dart:math' as math;

import 'package:latlong2/latlong.dart';

const _earthRadiusMeters = 6371000.0;

class RouteProjection {
  const RouteProjection({
    required this.point,
    required this.segmentIndex,
    required this.distanceMeters,
  });

  final LatLng point;
  final int segmentIndex;
  final double distanceMeters;
}

RouteProjection? projectOntoRoute(LatLng position, List<LatLng> points) {
  if (points.length < 2) return null;

  final cosLatitude = math.cos(position.latitudeInRad);
  RouteProjection? nearest;
  for (var i = 0; i < points.length - 1; i++) {
    final start = points[i];
    final end = points[i + 1];
    final (startX, startY) = _toLocalMeters(start, position, cosLatitude);
    final (endX, endY) = _toLocalMeters(end, position, cosLatitude);

    final dx = endX - startX;
    final dy = endY - startY;
    final lengthSquared = dx * dx + dy * dy;
    final t = lengthSquared == 0
        ? 0.0
        : (-(startX * dx + startY * dy) / lengthSquared).clamp(0.0, 1.0);

    final x = startX + t * dx;
    final y = startY + t * dy;
    final meters = math.sqrt(x * x + y * y);

    if (nearest != null && meters >= nearest.distanceMeters) continue;

    nearest = RouteProjection(
      point: LatLng(
        start.latitude + t * (end.latitude - start.latitude),
        start.longitude + t * (end.longitude - start.longitude),
      ),
      segmentIndex: i,
      distanceMeters: meters,
    );
  }
  return nearest;
}

(double, double) _toLocalMeters(
  LatLng point,
  LatLng origin,
  double cosLatitude,
) => (
  (point.longitudeInRad - origin.longitudeInRad) *
      cosLatitude *
      _earthRadiusMeters,
  (point.latitudeInRad - origin.latitudeInRad) * _earthRadiusMeters,
);
