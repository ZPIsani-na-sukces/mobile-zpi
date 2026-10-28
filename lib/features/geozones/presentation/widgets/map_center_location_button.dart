import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/geozones/controllers/displayed_location_controller.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/map_circle_button.dart';

class MapCenterLocationButton extends ConsumerWidget {
  const MapCenterLocationButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = MapController.of(context);

    return MapCircleButton(
      tooltip: 'Pokaż moją lokalizację',
      onPressed: () {
        final position = ref.read(displayedLocationProvider);
        if (position == null) return;
        controller.move(position.latLng, controller.camera.zoom);
      },
      icon: const Icon(Icons.my_location),
    );
  }
}
