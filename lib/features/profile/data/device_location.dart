import 'package:geolocator/geolocator.dart';

class LocationException implements Exception {
  const LocationException(this.message);

  final String message;
}

Future<({double latitude, double longitude})> readCurrentLocation() async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw const LocationException('Włącz lokalizację w telefonie.');
  }

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.denied) {
    throw const LocationException('Zezwól na lokalizację, żeby wykryć adres.');
  }
  if (permission == LocationPermission.deniedForever) {
    throw const LocationException(
      'Lokalizacja jest zablokowana. Włącz ją w ustawieniach telefonu.',
    );
  }

  final position = await Geolocator.getCurrentPosition();
  return (latitude: position.latitude, longitude: position.longitude);
}
