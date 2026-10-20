import 'dart:async';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_location_controller.g.dart';

@riverpod
class CurrentLocationController extends _$CurrentLocationController {
  @override
  Stream<LatLng> build() async* {
    final initial = await bg.BackgroundGeolocation.getCurrentPosition(
      samples: 1,
      persist: false,
    );
    yield _toLatLng(initial);

    final locations = StreamController<LatLng>();
    final watch = await bg.BackgroundGeolocation.watchPosition(
      interval: 5000,
      persist: false,
      onLocation: (location) => locations.add(_toLatLng(location)),
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

  LatLng _toLatLng(bg.Location location) =>
      LatLng(location.coords.latitude, location.coords.longitude);
}
