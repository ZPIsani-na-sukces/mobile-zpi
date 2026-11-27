import 'package:mobile_zpi/keys.dart';

import '../common/test_app.dart';

void main() {
  testApp('senior resets the password with an SMS code', (
    $,
    modules,
    system,
  ) async {
    await modules.auth.openPasswordReset();
    await modules.auth.resetPasswordBySms();
    await $(keys.login.page).waitUntilVisible();
  });
}
