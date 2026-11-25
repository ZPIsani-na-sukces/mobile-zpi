import 'package:mobile_zpi/main.dart' as app;
import 'package:patrol/patrol.dart';

void main() {
  patrolTest('app starts on Home and survives going to background', ($) async {
    await app.main();

    final mobile = $.platform.mobile;
    if (await mobile.isPermissionDialogVisible(
      timeout: const Duration(seconds: 5),
    )) {
      await mobile.grantPermissionWhenInUse();
    }

    await $('Start').waitUntilVisible();

    await $('Profil').tap();
    await $('Twoje dane osobowe').waitUntilVisible();

    await mobile.pressHome();
    await mobile.openApp();
    await $('Twoje dane osobowe').waitUntilVisible();
  });
}
