import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/compass_needle.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/map_circle_button.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';

class MapCompass extends StatelessWidget {
  const MapCompass({super.key});

  @override
  Widget build(BuildContext context) {
    final camera = MapCamera.of(context);
    final controller = MapController.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Align(
          alignment: Alignment.bottomRight,
          child: MapCircleButton(
            tooltip: 'Ustaw północ na górze',
            onPressed: () => controller.rotate(0),
            icon: Transform.rotate(
              angle: camera.rotationRad,
              child: const CompassNeedle(),
            ),
          ),
        ),
      ),
    );
  }
}
