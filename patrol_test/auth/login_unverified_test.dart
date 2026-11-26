import 'package:mobile_zpi/features/auth/shared/data/mock_auth_repository.dart';
import 'package:mobile_zpi/keys.dart';

import '../common/test_app.dart';

void main() {
  testApp('senior confirms the phone number while signing in', (
    $,
    modules,
    system,
  ) async {
    await modules.auth.openLogin();
    await modules.auth.signIn(password: mockUnverifiedPendingPassword);
    await modules.auth.confirmPhoneNumber();
    await system.allowLocationTracking();
    await $(keys.home.page).waitUntilVisible();
  });
}
