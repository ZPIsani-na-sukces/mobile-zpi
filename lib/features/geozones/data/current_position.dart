import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:latlong2/latlong.dart';

const maximumLocationAgeMillis = 10000;
const locationTimeoutSeconds = 15;

Future<LatLng> readCurrentPosition() async {
  final location = await bg.BackgroundGeolocation.getCurrentPosition(
    samples: 1,
    persist: false,
    maximumAge: maximumLocationAgeMillis,
    timeout: locationTimeoutSeconds,
  );
  return LatLng(location.coords.latitude, location.coords.longitude);
}
