import 'package:flutter_test/flutter_test.dart' show expect, isFalse;
import 'package:mobile_zpi/features/invitations/data/repository/mock_invitations_repository.dart';
import 'package:mobile_zpi/keys.dart';

import '../common/test_app.dart';
import '../common/test_data.dart';

void main() {
  testApp('senior adds a caretaker with a code and removes another', (
    $,
    modules,
    system,
  ) async {
    await modules.profile.open();
    await modules.profile.openCaretakers();
    await modules.caretakers.addWithCode(mockInvitationCode);
    await modules.caretakers.remove(TestData.caretakerRelationshipId);
    await $(keys.caretakers.card(TestData.invitedCaretakerRelationshipId))
        .scrollTo();
    expect(
      $(keys.caretakers.card(TestData.caretakerRelationshipId)).exists,
      isFalse,
    );
  });
}
