import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:mobile_zpi/features/profile/data/device_location.dart';

const _fixTimeout = Duration(seconds: 15);

class SosFix {
  const SosFix({
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
    required this.speedMps,
    required this.capturedAt,
  });

  factory SosFix.fromPosition(Position position) {
    final accuracy = position.accuracy;
    final speed = position.speed;
    return SosFix(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracyMeters: accuracy < 0 ? null : accuracy,
      speedMps: speed < 0 ? null : speed,
      capturedAt: position.timestamp,
    );
  }

  final double latitude;
  final double longitude;
  final double? accuracyMeters;
  final double? speedMps;
  final DateTime capturedAt;
}

Future<SosFix> readSosFix() async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw const LocationException('Włącz lokalizację w telefonie.');
  }

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.denied) {
    throw const LocationException(
      'Zezwól na lokalizację, żeby wysłać SOS z miejscem.',
    );
  }
  if (permission == LocationPermission.deniedForever) {
    throw const LocationException(
      'Lokalizacja jest zablokowana. Możesz wysłać SOS bez niej.',
    );
  }

  final position = await Geolocator.getCurrentPosition().timeout(
    _fixTimeout,
    onTimeout: () => throw const LocationException(
      'Nie udało się ustalić lokalizacji. Możesz wysłać SOS bez niej.',
    ),
  );
  return SosFix.fromPosition(position);
}
