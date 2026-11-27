import 'package:mobile_zpi/keys.dart';

import '../common/test_app.dart';

void main() {
  testApp('senior without location access still sends SOS', (
    $,
    modules,
    system,
  ) async {
    await modules.home.openSos();
    await modules.sos.waitUntilSent();
    await $(keys.sos.locationMissingRow).waitUntilExists();
  });
}
