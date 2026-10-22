import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/geozones/controllers/current_location_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/route_navigation_controller.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/geozone_map.dart';
import 'package:mobile_zpi/widgets/app_button.dart';

class MapStartNavigationButton extends ConsumerWidget {
  const MapStartNavigationButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = MapController.of(context);

    return AppButton.primary(
      label: 'Prowadź mnie',
      icon: Icons.navigation_outlined,
      onPressed: () {
        final position = ref.read(currentLocationControllerProvider).value;
        if (position != null) {
          controller.move(position.latLng, GeozoneMap.navigationZoom);
        }
        ref.read(routeNavigationControllerProvider.notifier).start();
      },
    );
  }
}
