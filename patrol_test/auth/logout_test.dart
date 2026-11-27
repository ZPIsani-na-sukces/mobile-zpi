import 'package:mobile_zpi/keys.dart';

import '../common/test_app.dart';
import '../common/test_data.dart';

void main() {
  testApp('senior signs out from the profile', ($, modules, system) async {
    await modules.auth.openLogin();
    await modules.auth.signIn(password: TestData.password);
    await system.allowLocationTracking();
    await modules.profile.open();
    await modules.profile.logout();
    await $(keys.login.page).waitUntilVisible();
  });
}
