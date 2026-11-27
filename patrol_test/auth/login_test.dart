import 'package:mobile_zpi/keys.dart';

import '../common/test_app.dart';
import '../common/test_data.dart';

void main() {
  testApp('senior signs in and lands on Home', ($, modules, system) async {
    await modules.auth.openLogin();
    await modules.auth.signIn(password: TestData.password);
    await system.allowLocationTracking();
    await $(keys.home.page).waitUntilVisible();
  });
}
