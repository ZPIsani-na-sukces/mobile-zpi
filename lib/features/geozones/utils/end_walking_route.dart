import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/geozones/controllers/current_location_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/walking_route_controller.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/geozone_map.dart';

void endWalkingRoute(WidgetRef ref, MapController controller) {
  ref.read(walkingRouteControllerProvider.notifier).clear();
  controller.rotate(0);
  final position = ref.read(currentLocationControllerProvider).value;
  if (position == null) return;
  controller.move(position.latLng, GeozoneMap.initialZoom);
}
