import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/geozones/controllers/current_location_controller.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/current_location_marker.dart';
import 'package:mobile_zpi/theme/app_colors.dart';

class CurrentLocationMarkerLayer extends HookConsumerWidget {
  const CurrentLocationMarkerLayer({super.key});

  static const double _accuracyCircleAlpha = 0.15;
  static const double _headingSectorAlpha = 0.6;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final positions = useMemoized(() {
      final controller = StreamController<LocationMarkerPosition>();
      final current = ref.read(currentLocationControllerProvider).value;
      if (current != null) controller.add(current);
      return controller;
    });
    useEffect(() => positions.close, [positions]);

    ref.listen(currentLocationControllerProvider, (_, next) {
      final position = next.value;
      if (position != null) positions.add(position);
    });

    return CurrentLocationLayer(
      positionStream: positions.stream,
      style: LocationMarkerStyle(
        marker: const CurrentLocationMarker(),
        markerSize: const Size.square(CurrentLocationMarker.size),
        accuracyCircleColor: AppColors.primary.withValues(
          alpha: _accuracyCircleAlpha,
        ),
        headingSectorColor: AppColors.primary.withValues(
          alpha: _headingSectorAlpha,
        ),
      ),
    );
  }
}
