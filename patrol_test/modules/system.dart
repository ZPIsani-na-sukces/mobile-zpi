import 'package:patrol/patrol.dart';

import 'module.dart';

final class System extends Module {
  System(super.$);

  MobileAutomator get _mobile => $.platform.mobile;

  /// Android 13+ asks for notifications on start, older versions ask nothing.
  Future<void> allowStartupPermissions() async {
    while (await _mobile.isPermissionDialogVisible(
      timeout: const Duration(seconds: 3),
    )) {
      await _mobile.grantPermissionWhenInUse();
    }
  }

  Future<void> allowLocation() async {
    if (await _mobile.isPermissionDialogVisible()) {
      await _mobile.grantPermissionWhenInUse();
    }
  }

  /// After sign-in the app starts location tracking. It asks for location,
  /// then explains why it needs "Allow all the time"; the test stays with
  /// "While using the app" and closes that explanation.
  Future<void> allowLocationTracking() async {
    await allowLocation();
    final rationaleCancel = Selector(text: 'Anuluj');
    try {
      await _mobile.tap(rationaleCancel, timeout: const Duration(seconds: 5));
    } on PatrolActionException {
      // Not shown, for example when the permission was already granted.
    }
  }

  Future<void> sendAppToBackgroundAndBack() async {
    await _mobile.pressHome();
    await _mobile.openApp();
  }
}
