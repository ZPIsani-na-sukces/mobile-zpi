import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/geozones/controllers/map_follow_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/walking_route_controller.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/geozone_map.dart';
import 'package:mobile_zpi/widgets/app_button.dart';

class MapShowWholeRouteButton extends ConsumerWidget {
  const MapShowWholeRouteButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = MapController.of(context);

    return AppButton.secondary(
      label: 'Cała trasa',
      icon: Icons.route_outlined,
      onPressed: () {
        final points =
            ref.read(walkingRouteControllerProvider).value?.points ?? const [];
        if (points.length < 2) return;
        ref.read(mapFollowControllerProvider.notifier).pause();
        controller.fitCamera(
          CameraFit.coordinates(
            coordinates: points,
            padding: GeozoneMap.routeFitPadding,
          ),
        );
      },
    );
  }
}
