import 'package:mobile_zpi/keys.dart';

import '../common/test_app.dart';
import '../common/test_data.dart';

void main() {
  testApp('senior sends SOS with location and returns home', (
    $,
    modules,
    system,
  ) async {
    // Only the map asks for location without a session.
    await modules.home.openZone(TestData.zoneId);
    await system.allowLocation();
    await modules.geozone.close();
    await modules.home.openSos();
    await modules.sos.waitUntilSent();
    await $(keys.sos.locationSentRow).waitUntilExists();
    await modules.sos.close();
    await $(keys.home.page).waitUntilVisible();
  });
}
