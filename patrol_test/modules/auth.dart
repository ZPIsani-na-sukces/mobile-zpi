import 'package:flutter/widgets.dart';
import 'package:mobile_zpi/features/auth/shared/data/mock_auth_repository.dart';
import 'package:mobile_zpi/keys.dart';
import 'package:patrol/patrol.dart';

import '../common/test_data.dart';
import 'module.dart';

/// With `USE_MOCKS=true` the app starts on Home, so the auth screens are
/// opened from the Dev section of the profile.
final class Auth extends Module {
  Auth(super.$);

  Future<void> openLogin() => _openFromDevSection(keys.profile.devLoginButton);

  Future<void> openRegistration() =>
      _openFromDevSection(keys.profile.devRegisterButton);

  Future<void> openPasswordReset() =>
      _openFromDevSection(keys.profile.devResetPassButton);

  Future<void> signIn({
    required String password,
    String identifier = TestData.phone,
  }) async {
    await $(keys.login.identifierInput).enterText(identifier);
    await $(keys.login.passwordInput).enterText(password);
    await $(keys.login.loginButton).scrollTo().tap();
  }

  Future<void> register() async {
    await $(keys.register.firstNameInput).enterText(TestData.firstName);
    await $(keys.register.lastNameInput).enterText(TestData.lastName);
    await $(keys.register.phoneInput).enterText(TestData.phone);
    await $(keys.register.nextButton).scrollTo().tap();
    await $(keys.register.passwordInput).enterText(TestData.password);
    await $(keys.register.repeatPasswordInput).enterText(TestData.password);
    await $(keys.register.registerButton).scrollTo().tap();
  }

  /// The code input confirms by itself once all digits are in.
  Future<void> confirmPhoneNumber() async {
    await $(keys.accActivation.codeInput).enterText(mockSmsCode);
  }

  Future<void> resetPasswordBySms() async {
    await $(keys.resetPass.phoneInput).enterText(TestData.phone);
    await $(keys.resetPass.sendCodeButton).scrollTo().tap();
    await $(keys.resetPass.smsCodeInput).enterText(mockSmsCode);
    await $(keys.resetPass.newPasswordInput).enterText(TestData.newPassword);
    await $(keys.resetPass.repeatPasswordInput).enterText(TestData.newPassword);
    await $(keys.resetPass.changePasswordButton).scrollTo().tap();
  }

  Future<void> _openFromDevSection(Key devButton) async {
    await $(keys.widgets.navProfile).tap();
    await $(devButton).scrollTo().tap();
  }
}
