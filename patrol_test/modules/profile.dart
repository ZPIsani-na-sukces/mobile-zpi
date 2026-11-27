import 'package:flutter/widgets.dart';
import 'package:mobile_zpi/keys.dart';
import 'package:patrol/patrol.dart';

import 'module.dart';

final class Profile extends Module {
  Profile(super.$);

  Future<void> open() async {
    await $(keys.widgets.navProfile).tap();
  }

  Future<void> openEdit() async {
    await $(keys.profile.editButton).scrollTo().tap();
  }

  Future<void> openCaretakers() async {
    await $(keys.profile.caretakersCard).tap();
  }

  Future<void> toggleHighContrast() async {
    await $(keys.profile.highContrastSwitch).scrollTo().tap();
  }

  Future<void> logout() async {
    await $(keys.profile.logoutButton).scrollTo().tap();
    await $(keys.profile.logoutConfirmButton).tap();
  }

  /// [value] is the text or the [RegExp] shown in the [row] of the profile.
  /// After an edit the list may be scrolled past the row, so it scrolls up.
  Future<void> expectValue(Key row, Pattern value) async {
    await $(row).$(value).scrollTo(scrollDirection: AxisDirection.up);
  }

  Future<void> changeName({
    required String firstName,
    required String lastName,
  }) async {
    await $(keys.profileEdit.firstNameInput).enterText(firstName);
    await $(keys.profileEdit.lastNameInput).enterText(lastName);
  }

  Future<void> changeAddress({
    required String city,
    required String street,
  }) async {
    await $(keys.profileEdit.cityInput).scrollTo().enterText(city);
    await $(keys.profileEdit.streetInput).scrollTo().enterText(street);
  }

  Future<void> saveEdit() async {
    await $(keys.profileEdit.saveButton).scrollTo().tap();
  }

  Future<void> changeEmail({
    required String email,
    required String code,
  }) async {
    await $(keys.profileEdit.emailChangeCard).scrollTo().tap();
    await $(keys.contactChange.valueInput).enterText(email);
    await $(keys.contactChange.sendCodeButton).tap();
    await $(keys.contactChange.emailCodeInput).enterText(code);
    await $(keys.contactChange.confirmButton).tap();
  }
}
