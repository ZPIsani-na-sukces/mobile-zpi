import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/geozones/controllers/current_location_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/walking_route_controller.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/geozone_map.dart';
import 'package:mobile_zpi/widgets/app_button.dart';

class MapCancelRouteButton extends ConsumerWidget {
  const MapCancelRouteButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = MapController.of(context);

    return AppButton.primary(
      label: 'Zakończ',
      icon: Icons.close,
      onPressed: () {
        ref.read(walkingRouteControllerProvider.notifier).clear();
        final position = ref.read(currentLocationControllerProvider).value;
        if (position == null) return;
        controller.move(position.latLng, GeozoneMap.initialZoom);
      },
    );
  }
}
