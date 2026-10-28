import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/geozones/controllers/walking_route_controller.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/walking_route_destination_marker.dart';
import 'package:mobile_zpi/theme/app_colors.dart';

class WalkingRouteLayer extends ConsumerWidget {
  const WalkingRouteLayer({super.key});

  static const double _strokeWidth = 6;
  static const double _borderStrokeWidth = 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(walkingRouteControllerProvider).value;
    if (route == null || route.points.isEmpty) return const SizedBox.shrink();

    return Stack(
      children: [
        PolylineLayer(
          polylines: [
            Polyline(
              points: route.points,
              color: context.colors.primary,
              strokeWidth: _strokeWidth,
              borderColor: context.colors.surface,
              borderStrokeWidth: _borderStrokeWidth,
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: route.points.last,
              width: WalkingRouteDestinationMarker.size,
              height: WalkingRouteDestinationMarker.size,
              child: const WalkingRouteDestinationMarker(),
            ),
          ],
        ),
      ],
    );
  }
}
