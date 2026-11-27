// GENERATED CODE - DO NOT MODIFY BY HAND AND DO NOT COMMIT TO VERSION CONTROL
// ignore_for_file: type=lint, invalid_use_of_internal_member

import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:patrol/src/constants.dart' as constants;
import 'package:patrol/src/manifest_writer.dart';
import 'package:patrol/src/platform/contracts/contracts.dart';
import 'package:patrol/src/platform/mobile/patrol_runtime_ports.dart';
import 'package:test_api/src/backend/invoker.dart';

// START: GENERATED TEST IMPORTS
import 'auth/login_test.dart' as auth__login_test;
import 'auth/login_unverified_test.dart' as auth__login_unverified_test;
import 'auth/login_wrong_password_test.dart' as auth__login_wrong_password_test;
import 'auth/logout_test.dart' as auth__logout_test;
import 'auth/register_test.dart' as auth__register_test;
import 'auth/reset_password_test.dart' as auth__reset_password_test;
import 'home/home_contacts_test.dart' as home__home_contacts_test;
import 'home/home_shortcuts_test.dart' as home__home_shortcuts_test;
import 'profile/caretakers_manage_test.dart' as profile__caretakers_manage_test;
import 'profile/caretakers_send_code_test.dart' as profile__caretakers_send_code_test;
import 'profile/profile_edit_test.dart' as profile__profile_edit_test;
import 'profile/profile_email_change_test.dart' as profile__profile_email_change_test;
import 'profile/profile_high_contrast_test.dart' as profile__profile_high_contrast_test;
import 'sos/sos_send_test.dart' as sos__sos_send_test;
import 'sos/sos_without_location_test.dart' as sos__sos_without_location_test;
import 'vps/vps_smoke_test.dart' as vps__vps_smoke_test;
// END: GENERATED TEST IMPORTS

Future<void> main() async {
  // This is the entrypoint of the bundled Dart test.
  //
  // Its responsibilities are:
  //  * Running a special Dart test that runs before all the other tests and
  //    explores the hierarchy of groups and tests.
  //  * Hosting a PatrolAppService, which the native side of Patrol uses to get
  //    the Dart tests, and to request execution of a specific Dart test.
  //
  // When running on Android, the Android Test Orchestrator, before running the
  // tests, makes an initial run to gather the tests that it will later run. The
  // native side of Patrol (specifically: PatrolJUnitRunner class) is hooked
  // into the Android Test Orchestrator lifecycle and knows when that initial
  // run happens. When it does, PatrolJUnitRunner makes an RPC call to
  // PatrolAppService and asks it for Dart tests.
  //
  // When running on iOS, the native side of Patrol (specifically: the
  // PATROL_INTEGRATION_TEST_IOS_RUNNER macro) makes an initial run to gather
  // the tests that it will later run (same as the Android). During that initial
  // run, it makes an RPC call to PatrolAppService and asks it for Dart tests.
  //
  // Once the native runner has the list of Dart tests, it dynamically creates
  // native test cases from them. On Android, this is done using the
  // Parametrized JUnit runner. On iOS, new test case methods are swizzled into
  // the RunnerUITests class, taking advantage of the very dynamic nature of
  // Objective-C runtime.
  //
  // Execution of these dynamically created native test cases is then fully
  // managed by the underlying native test framework (JUnit on Android, XCTest
  // on iOS). The native test cases do only one thing - request execution of the
  // Dart test (out of which they had been created) and wait for it to complete.
  // The result of running the Dart test is the result of the native test case.

  final testExplorationCompleter = Completer<DartGroupEntry>();

  // In build-time discovery mode the bundle is driven by a host `flutter test`
  // run: we only register tests to build the group tree, then serialize it to a
  // manifest. PatrolBinding (a Live binding) must NOT be initialized here - it's
  // incompatible with the automated binding `flutter test` installs on the host.
  late final PlatformAutomator platformAutomator;
  late final PatrolBinding binding;
  if (!constants.testDiscoveryEnabled) {
    platformAutomator = PlatformAutomator(
      config: PlatformAutomatorConfig.defaultConfig(),
    );
    await platformAutomator.initialize();
    binding = PatrolBinding.ensureInitialized(platformAutomator);
  }

  // A special test to explore the hierarchy of groups and tests. This is a hack
  // around https://github.com/dart-lang/test/issues/1998.
  //
  // This test must be the first to run. If not, the native side likely won't
  // receive any tests, and everything will fall apart.
  test('patrol_test_explorer', () {
    // Maybe somewhat counterintuitively, this callback runs *after* the calls
    // to group() below.
    final topLevelGroup = Invoker.current!.liveTest.groups.first;
    final dartTestGroup = createDartTestGroup(
      topLevelGroup,
      tags: null,
      excludeTags: 'vps',
    );
    if (constants.testDiscoveryEnabled) {
      // Build-time discovery: serialize the WHOLE tree (same shape as
      // ListDartTestsResponse.group) so the native side can flatten it with its
      // existing listTestsFlat logic - selectors come out byte-identical to
      // runtime discovery.
      //
      // The manifest is written from inside this test (not from main()) on
      // purpose: under the host automated binding the framework runs tests only
      // *after* main() finishes declaring, so awaiting the tree in main() would
      // deadlock.
      const manifestOutput = String.fromEnvironment('PATROL_MANIFEST_OUTPUT');
      if (manifestOutput.isNotEmpty) {
        writeTestManifest(
          manifestOutput,
          jsonEncode(ListDartTestsResponse(group: dartTestGroup).toJson()),
        );
      }
      return;
    }

    testExplorationCompleter.complete(dartTestGroup);
    print('patrol_test_explorer: obtained Dart-side test hierarchy:');
    reportGroupStructure(dartTestGroup);
  });

// START: GENERATED TEST GROUPS
  group('auth.login_test', auth__login_test.main);
  group('auth.login_unverified_test', auth__login_unverified_test.main);
  group('auth.login_wrong_password_test', auth__login_wrong_password_test.main);
  group('auth.logout_test', auth__logout_test.main);
  group('auth.register_test', auth__register_test.main);
  group('auth.reset_password_test', auth__reset_password_test.main);
  group('home.home_contacts_test', home__home_contacts_test.main);
  group('home.home_shortcuts_test', home__home_shortcuts_test.main);
  group('profile.caretakers_manage_test', profile__caretakers_manage_test.main);
  group('profile.caretakers_send_code_test', profile__caretakers_send_code_test.main);
  group('profile.profile_edit_test', profile__profile_edit_test.main);
  group('profile.profile_email_change_test', profile__profile_email_change_test.main);
  group('profile.profile_high_contrast_test', profile__profile_high_contrast_test.main);
  group('sos.sos_send_test', sos__sos_send_test.main);
  group('sos.sos_without_location_test', sos__sos_without_location_test.main);
  group('vps.vps_smoke_test', vps__vps_smoke_test.main);
// END: GENERATED TEST GROUPS

  if (constants.testDiscoveryEnabled) {
    // Returning finishes declaration; `flutter test` then runs the explorer
    // test (which writes the manifest) plus the registered no-op bodies.
    return;
  }

  final dartTestGroup = await testExplorationCompleter.future;
  final appService = PatrolAppService(topLevelDartTestGroup: dartTestGroup);
  binding.patrolAppService = appService;
  await PatrolRuntimePorts.ensureLoaded();
  await runAppService(appService);

  // Until now, the native test runner was waiting for us, the Dart side, to
  // come alive. Now that we did, let's tell it that we're ready to be asked
  // about Dart tests.
  await platformAutomator.markPatrolAppServiceReady();

  await appService.testExecutionCompleted;
}
