import 'package:flutter/widgets.dart';

class _ProfileKey extends ValueKey<String> {
  const _ProfileKey(String value) : super('profile_$value');
}

class ProfileKeys {
  final addressRow = const _ProfileKey('addressRow');
  final caretakersCard = const _ProfileKey('caretakersCard');
  final devLoginButton = const _ProfileKey('devLoginButton');
  final devRegisterButton = const _ProfileKey('devRegisterButton');
  final devResetPassButton = const _ProfileKey('devResetPassButton');
  final editButton = const _ProfileKey('editButton');
  final emailRow = const _ProfileKey('emailRow');
  final emailVerifiedRow = const _ProfileKey('emailVerifiedRow');
  final highContrastSwitch = const _ProfileKey('highContrastSwitch');
  final logoutButton = const _ProfileKey('logoutButton');
  final logoutConfirmButton = const _ProfileKey('logoutConfirmButton');
  final nameRow = const _ProfileKey('nameRow');
}

class _ProfileEditKey extends ValueKey<String> {
  const _ProfileEditKey(String value) : super('profileEdit_$value');
}

class ProfileEditKeys {
  final cityInput = const _ProfileEditKey('cityInput');
  final emailChangeCard = const _ProfileEditKey('emailChangeCard');
  final firstNameInput = const _ProfileEditKey('firstNameInput');
  final lastNameInput = const _ProfileEditKey('lastNameInput');
  final saveButton = const _ProfileEditKey('saveButton');
  final streetInput = const _ProfileEditKey('streetInput');
}

class _ContactChangeKey extends ValueKey<String> {
  const _ContactChangeKey(String value) : super('contactChange_$value');
}

class ContactChangeKeys {
  final confirmButton = const _ContactChangeKey('confirmButton');
  final emailCodeInput = const _ContactChangeKey('emailCodeInput');
  final sendCodeButton = const _ContactChangeKey('sendCodeButton');
  final valueInput = const _ContactChangeKey('valueInput');
}
