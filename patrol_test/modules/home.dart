import 'package:flutter/widgets.dart';
import 'package:mobile_zpi/keys.dart';
import 'package:patrol/patrol.dart';

import 'module.dart';

final class Home extends Module {
  Home(super.$);

  Future<void> openSos() async {
    await $(keys.home.sosButton)
        .scrollTo(scrollDirection: AxisDirection.up)
        .tap();
  }

  Future<void> openAllContacts() async {
    await $(keys.home.allContactsButton).scrollTo().tap();
  }

  Future<void> openContact(String contactId) async {
    await $(keys.home.contactTile(contactId)).scrollTo().tap();
  }

  Future<void> openTask(String occurrenceId) async {
    await $(keys.home.taskTile(occurrenceId)).scrollTo().tap();
  }

  Future<void> openZone(String zoneId) async {
    await $(keys.home.zoneTile(zoneId)).scrollTo().tap();
  }
}
