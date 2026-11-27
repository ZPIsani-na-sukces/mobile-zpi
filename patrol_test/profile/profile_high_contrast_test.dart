import 'package:flutter/material.dart';
import 'package:mobile_zpi/keys.dart';

import '../common/test_app.dart';

void main() {
  testApp('senior turns on high contrast and it stays on', (
    $,
    modules,
    system,
  ) async {
    await modules.profile.open();
    await modules.profile.toggleHighContrast();
    await modules.navigation.openHomeTab();
    await modules.profile.open();
    await $(keys.profile.highContrastSwitch)
        .$(Switch)
        .which<Switch>((s) => s.value)
        .waitUntilExists();
  });
}
