import 'dart:async';

import 'package:mobile_zpi/main.dart' as app;
import 'package:patrol/patrol.dart';

import '../modules/modules.dart';
import '../modules/system.dart';

typedef TestAppBody = Future<void> Function(
  PatrolIntegrationTester $,
  Modules modules,
  System system,
);

/// Starts the app on Home and answers its startup permission dialogs.
///
/// Every test runs in a fresh process with cleared app data and permissions,
/// so with `USE_MOCKS=true` the app opens on Home without a session.
void testApp(String description, TestAppBody body, {List<String>? tags}) {
  patrolTest(description, tags: tags, ($) async {
    final system = System($);
    // main() ends by awaiting the background geolocation headless task,
    // which does not answer under the test runner for about 10 minutes.
    // The app is already running by then, so the test does not wait for it.
    unawaited(app.main());
    await system.allowStartupPermissions();
    await body($, Modules($), system);
  });
}
