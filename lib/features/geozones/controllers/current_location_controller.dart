import 'dart:async';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_location_controller.g.dart';

@riverpod
class CurrentLocationController extends _$CurrentLocationController {
  @override
  Stream<LocationMarkerPosition> build() async* {
    final initial = await bg.BackgroundGeolocation.getCurrentPosition(
      samples: 1,
      persist: false,
    );
    yield _toMarkerPosition(initial);

    final locations = StreamController<LocationMarkerPosition>();
    final watch = await bg.BackgroundGeolocation.watchPosition(
      interval: 5000,
      persist: false,
      onLocation: (location) => locations.add(_toMarkerPosition(location)),
    );

    if (!ref.mounted) {
      await watch.remove();
      await locations.close();
      return;
    }

    ref.onDispose(() {
      watch.remove();
      locations.close();
    });

    yield* locations.stream;
  }

  LocationMarkerPosition _toMarkerPosition(bg.Location location) =>
      LocationMarkerPosition(
        latitude: location.coords.latitude,
        longitude: location.coords.longitude,
        accuracy: location.coords.accuracy >= 0
            ? location.coords.accuracy
            : double.nan,
      );
}
