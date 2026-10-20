import 'package:flutter/foundation.dart';
import 'package:mobile_zpi/features/profile/data/models/home_address.dart';
import 'package:url_launcher/url_launcher.dart';

class BackHomeException implements Exception {
  const BackHomeException();
}

/// Opens walking navigation to [home] in the platform maps app.
Future<void> navigateBackHome(Coordinates home) async {
  final destination = '${home.latitude},${home.longitude}';
  final uri = defaultTargetPlatform == TargetPlatform.iOS
      ? Uri.https('maps.apple.com', '/', {'daddr': destination, 'dirflg': 'w'})
      : Uri.https('www.google.com', '/maps/dir/', {
          'api': '1',
          'destination': destination,
          'travelmode': 'walking',
          'dir_action': 'navigate',
        });
  final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!opened) throw const BackHomeException();
}
