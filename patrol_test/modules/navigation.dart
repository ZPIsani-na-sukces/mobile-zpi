import 'package:flutter/material.dart';
import 'package:mobile_zpi/keys.dart';

import 'module.dart';

final class Navigation extends Module {
  Navigation(super.$);

  Future<void> goBack() async {
    await $(BackButton).tap();
  }

  Future<void> openHomeTab() async {
    await $(keys.widgets.navHome).tap();
  }

  Future<void> openProfileTab() async {
    await $(keys.widgets.navProfile).tap();
  }
}
