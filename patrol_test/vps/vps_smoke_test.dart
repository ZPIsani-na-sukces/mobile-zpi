import 'package:mobile_zpi/keys.dart';

import '../common/test_app.dart';

/// Real backend: build with `USE_MOCKS=false` and pass the account with
/// `--dart-define=E2E_LOGIN=... --dart-define=E2E_PASSWORD=...`.
/// Signs in and reads data only, so it leaves nothing in the database.
void main() {
  testApp('senior signs in on the real backend and sees Home and Profile', (
    $,
    modules,
    system,
  ) async {
    await modules.auth.signIn(
      identifier: const String.fromEnvironment('E2E_LOGIN'),
      password: const String.fromEnvironment('E2E_PASSWORD'),
    );
    await system.allowLocationTracking();
    await $(keys.home.page).waitUntilVisible();
    await modules.profile.open();
    await $(keys.profile.nameRow).waitUntilVisible();
  }, tags: ['vps']);
}
