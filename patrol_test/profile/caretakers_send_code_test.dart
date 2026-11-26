import 'package:flutter/material.dart';
import 'package:mobile_zpi/keys.dart';

import '../common/test_app.dart';

void main() {
  testApp('senior shows a code for a new caretaker and copies it', (
    $,
    modules,
    system,
  ) async {
    await modules.profile.open();
    await modules.profile.openCaretakers();
    await modules.caretakers.showMyCode();
    await $(keys.sendInvitation.code).waitUntilVisible();
    await modules.caretakers.copyMyCode();
    await $(SnackBar).waitUntilVisible();
  });
}
