import 'package:mobile_zpi/keys.dart';

import '../common/test_app.dart';

void main() {
  testApp('senior registers, confirms the phone and lands on Home', (
    $,
    modules,
    system,
  ) async {
    await modules.auth.openRegistration();
    await modules.auth.register();
    await modules.auth.confirmPhoneNumber();
    await system.allowLocationTracking();
    await $(keys.home.page).waitUntilVisible();
  });
}
