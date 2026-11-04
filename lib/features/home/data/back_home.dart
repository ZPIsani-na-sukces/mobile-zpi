import 'package:mobile_zpi/features/profile/data/models/home_address.dart';

/// Walking navigation to [home] in Google Maps.
Uri googleMapsDirections(Coordinates home) =>
    Uri.https('www.google.com', '/maps/dir/', {
      'api': '1',
      'destination': '${home.latitude},${home.longitude}',
      'travelmode': 'walking',
      'dir_action': 'navigate',
    });
