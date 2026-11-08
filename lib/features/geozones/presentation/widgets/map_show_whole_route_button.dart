import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/geozones/controllers/map_follow_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/walking_route_controller.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/geozone_map.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/map_circle_button.dart';

class MapShowWholeRouteButton extends ConsumerWidget {
  const MapShowWholeRouteButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = MapController.of(context);

    return MapCircleButton(
      tooltip: 'Pokaż całą trasę',
      onPressed: () {
        final points =
            ref.read(walkingRouteControllerProvider).value?.points ?? const [];
        if (points.length < 2) return;
        ref.read(mapFollowControllerProvider.notifier).pause();
        controller
          ..rotate(0)
          ..fitCamera(
            CameraFit.coordinates(
              coordinates: points,
              padding: GeozoneMap.routeFitPadding,
            ),
          );
      },
      icon: const Icon(Icons.zoom_out_map),
    );
  }
}
