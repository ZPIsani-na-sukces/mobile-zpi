import 'package:mobile_zpi/keys.dart';

import '../common/test_app.dart';
import '../common/test_data.dart';

void main() {
  testApp('senior opens a contact from the list and returns to Home', (
    $,
    modules,
    system,
  ) async {
    await modules.home.openAllContacts();
    await modules.contacts.openContact(TestData.contactId);
    await $(keys.contactDetails.page).waitUntilVisible();
    await modules.navigation.goBack();
    await modules.navigation.goBack();
    await system.sendAppToBackgroundAndBack();
    await $(keys.home.page).waitUntilVisible();
  });
}
