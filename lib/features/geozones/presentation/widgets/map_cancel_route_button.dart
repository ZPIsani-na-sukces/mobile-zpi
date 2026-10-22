import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/geozones/controllers/current_location_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/walking_route_controller.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/geozone_map.dart';
import 'package:mobile_zpi/widgets/app_button.dart';

class MapCancelRouteButton extends ConsumerWidget {
  const MapCancelRouteButton({
    super.key,
    required this.label,
    this.variant = AppButtonVariant.primary,
  });

  final String label;
  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = MapController.of(context);

    return AppButton(
      label: label,
      icon: Icons.close,
      variant: variant,
      onPressed: () {
        ref.read(walkingRouteControllerProvider.notifier).clear();
        controller.rotate(0);
        final position = ref.read(currentLocationControllerProvider).value;
        if (position == null) return;
        controller.move(position.latLng, GeozoneMap.initialZoom);
      },
    );
  }
}
