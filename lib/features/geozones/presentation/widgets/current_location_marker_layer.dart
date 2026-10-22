import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/geozones/controllers/current_location_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/map_follow_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/route_navigation_controller.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/current_location_marker.dart';
import 'package:mobile_zpi/theme/app_colors.dart';

class CurrentLocationMarkerLayer extends HookConsumerWidget {
  const CurrentLocationMarkerLayer({super.key});

  static const double _accuracyCircleAlpha = 0.15;
  static const double _headingSectorAlpha = 0.6;
  static const Duration _alignDirectionAnimationDuration = Duration(
    milliseconds: 300,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final positions = useMemoized(() {
      final controller = StreamController<LocationMarkerPosition>();
      final current = ref.read(currentLocationControllerProvider).value;
      if (current != null) controller.add(current);
      return controller;
    });
    useEffect(() => positions.close, [positions]);

    final alignPosition = useMemoized(StreamController<double?>.new);
    useEffect(() => alignPosition.close, [alignPosition]);

    ref.listen(currentLocationControllerProvider, (_, next) {
      final position = next.value;
      if (position != null) positions.add(position);
    });

    final isNavigating = ref.watch(routeNavigationControllerProvider);
    final following = ref.watch(mapFollowControllerProvider);
    final alignOnUpdate = following
        ? AlignOnUpdate.always
        : AlignOnUpdate.never;

    useEffect(() {
      if (following) alignPosition.add(null);
      return null;
    }, [following]);

    return CurrentLocationLayer(
      positionStream: positions.stream,
      alignPositionStream: alignPosition.stream,
      alignPositionOnUpdate: alignOnUpdate,
      alignDirectionOnUpdate: alignOnUpdate,
      alignDirectionAnimationDuration: _alignDirectionAnimationDuration,
      style: LocationMarkerStyle(
        marker: CurrentLocationMarker(showDirection: isNavigating),
        markerSize: const Size.square(CurrentLocationMarker.size),
        markerDirection: isNavigating
            ? MarkerDirection.heading
            : MarkerDirection.top,
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
