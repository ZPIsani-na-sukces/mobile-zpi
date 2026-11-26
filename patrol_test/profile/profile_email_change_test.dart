import 'package:mobile_zpi/features/profile/data/repository/mock_profile_repository.dart';
import 'package:mobile_zpi/keys.dart';

import '../common/test_app.dart';
import '../common/test_data.dart';

void main() {
  testApp('senior adds an e-mail confirmed with a code', (
    $,
    modules,
    system,
  ) async {
    await modules.profile.open();
    await modules.profile.openEdit();
    await modules.profile.changeEmail(
      email: TestData.email,
      code: mockContactChangeCode,
    );
    await modules.navigation.goBack();
    await modules.profile.expectValue(keys.profile.emailRow, TestData.email);
    await modules.profile.expectValue(keys.profile.emailVerifiedRow, 'Tak');
  });
}
