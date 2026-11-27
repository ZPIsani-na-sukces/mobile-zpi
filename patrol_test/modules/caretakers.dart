import 'package:mobile_zpi/keys.dart';
import 'package:patrol/patrol.dart';

import 'module.dart';

final class Caretakers extends Module {
  Caretakers(super.$);

  /// The code input checks the code by itself once all digits are in.
  Future<void> addWithCode(String code) async {
    await $(keys.caretakers.addButton).scrollTo().tap();
    await $(keys.addCaretaker.enterCodeButton).tap();
    await $(keys.acceptInvitation.codeInput).enterText(code);
    await $(keys.acceptInvitation.acceptButton).tap();
  }

  Future<void> remove(String relationshipId) async {
    await $(keys.caretakers.removeButton(relationshipId)).scrollTo().tap();
    await $(keys.caretakers.removeConfirmButton).tap();
  }

  Future<void> showMyCode() async {
    await $(keys.caretakers.addButton).scrollTo().tap();
    await $(keys.addCaretaker.showMyCodeButton).tap();
  }

  Future<void> copyMyCode() async {
    await $(keys.sendInvitation.copyButton).tap();
  }
}
