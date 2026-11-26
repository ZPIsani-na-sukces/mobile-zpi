import 'package:mobile_zpi/keys.dart';

import '../common/test_app.dart';
import '../common/test_data.dart';

void main() {
  testApp('senior changes the name and the home address', (
    $,
    modules,
    system,
  ) async {
    await modules.profile.open();
    await modules.profile.openEdit();
    await modules.profile.changeName(
      firstName: TestData.firstName,
      lastName: TestData.lastName,
    );
    await modules.profile.changeAddress(
      city: TestData.city,
      street: TestData.street,
    );
    await modules.profile.saveEdit();
    await modules.profile.expectValue(
      keys.profile.nameRow,
      '${TestData.firstName} ${TestData.lastName}',
    );
    await modules.profile.expectValue(
      keys.profile.addressRow,
      RegExp(TestData.city),
    );
  });
}
