import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

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

/// Never asks for permission or shows an error, so SOS goes out without a
/// location instead of waiting on the user.
Future<SosFix?> readSosFix() async {
  try {
    if (!await Geolocator.isLocationServiceEnabled()) return null;
    final permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return null;
    }
    final position = await Geolocator.getCurrentPosition().timeout(_fixTimeout);
    return SosFix.fromPosition(position);
  } catch (error) {
    debugPrint('SOS location failed: $error');
    return null;
  }
}
