import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/geozones/controllers/displayed_location_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/map_follow_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/route_navigation_controller.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/current_location_marker.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/geozone_map.dart';
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
      final current = ref.read(displayedLocationProvider);
      if (current != null) controller.add(current);
      return controller;
    });
    useEffect(() => positions.close, [positions]);

    final alignPosition = useMemoized(StreamController<double?>.new);
    useEffect(() => alignPosition.close, [alignPosition]);

    ref.listen(displayedLocationProvider, (_, next) {
      if (next != null) positions.add(next);
    });

    final isNavigating = ref.watch(routeNavigationControllerProvider);
    final following = ref.watch(mapFollowControllerProvider);
    final alignOnUpdate = following
        ? AlignOnUpdate.always
        : AlignOnUpdate.never;

    useEffect(() {
      if (following) alignPosition.add(GeozoneMap.navigationZoom);
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
        accuracyCircleColor: context.colors.primary.withValues(
          alpha: _accuracyCircleAlpha,
        ),
        headingSectorColor: context.colors.primary.withValues(
          alpha: _headingSectorAlpha,
        ),
      ),
    );
  }
}
