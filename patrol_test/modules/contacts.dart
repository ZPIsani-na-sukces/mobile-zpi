import 'package:mobile_zpi/keys.dart';
import 'package:patrol/patrol.dart';

import 'module.dart';

final class Contacts extends Module {
  Contacts(super.$);

  Future<void> openContact(String contactId) async {
    await $(keys.contacts.contactTile(contactId)).scrollTo().tap();
  }
}
