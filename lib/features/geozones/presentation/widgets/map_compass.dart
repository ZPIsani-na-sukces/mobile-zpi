import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/geozones/controllers/map_follow_controller.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/compass_needle.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/map_circle_button.dart';

class MapCompass extends ConsumerWidget {
  const MapCompass({super.key});

  static const double _northUpToleranceDegrees = 1;
  static const Duration _animationDuration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final camera = MapCamera.of(context);
    final controller = MapController.of(context);
    final following = ref.watch(mapFollowControllerProvider);

    final rotation = camera.rotation % 360;
    final isNorthUp =
        rotation < _northUpToleranceDegrees ||
        rotation > 360 - _northUpToleranceDegrees;
    final visible = !isNorthUp && !following;

    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: _animationDuration,
        child: MapCircleButton(
          tooltip: 'Ustaw północ na górze',
          onPressed: () => controller.rotate(0),
          icon: Transform.rotate(
            angle: camera.rotationRad,
            child: const CompassNeedle(),
          ),
        ),
      ),
    );
  }
}
