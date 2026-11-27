import 'package:mobile_zpi/features/auth/shared/data/mock_auth_repository.dart';
import 'package:mobile_zpi/keys.dart';

import '../common/test_app.dart';

void main() {
  testApp('senior sees an error after a wrong password', (
    $,
    modules,
    system,
  ) async {
    await modules.auth.openLogin();
    await modules.auth.signIn(password: mockWrongPassword);
    await $(keys.login.errorText).waitUntilVisible();
  });
}
