import 'package:flutter/foundation.dart';
import 'package:mobile_zpi/features/profile/data/models/home_address.dart';
import 'package:url_launcher/url_launcher.dart';

class BackHomeException implements Exception {
  const BackHomeException();
}

/// Walking navigation to [home] in Google Maps.
Uri googleMapsDirections(Coordinates home) =>
    Uri.https('www.google.com', '/maps/dir/', {
      'api': '1',
      'destination': '${home.latitude},${home.longitude}',
      'travelmode': 'walking',
      'dir_action': 'navigate',
    });

/// Opens walking navigation to [home] in the platform maps app.
Future<void> navigateBackHome(Coordinates home) async {
  final destination = '${home.latitude},${home.longitude}';
  final uri = defaultTargetPlatform == TargetPlatform.iOS
      ? Uri.https('maps.apple.com', '/', {'daddr': destination, 'dirflg': 'w'})
      : googleMapsDirections(home);
  final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!opened) throw const BackHomeException();
}
