import 'package:flutter/widgets.dart';

class _LoginKey extends ValueKey<String> {
  const _LoginKey(String value) : super('login_$value');
}

class LoginKeys {
  final errorText = const _LoginKey('errorText');
  final identifierInput = const _LoginKey('identifierInput');
  final loginButton = const _LoginKey('loginButton');
  final page = const _LoginKey('page');
  final passwordInput = const _LoginKey('passwordInput');
}

class _RegisterKey extends ValueKey<String> {
  const _RegisterKey(String value) : super('register_$value');
}

class RegisterKeys {
  final firstNameInput = const _RegisterKey('firstNameInput');
  final lastNameInput = const _RegisterKey('lastNameInput');
  final nextButton = const _RegisterKey('nextButton');
  final passwordInput = const _RegisterKey('passwordInput');
  final phoneInput = const _RegisterKey('phoneInput');
  final registerButton = const _RegisterKey('registerButton');
  final repeatPasswordInput = const _RegisterKey('repeatPasswordInput');
}

class _AccActivationKey extends ValueKey<String> {
  const _AccActivationKey(String value) : super('accActivation_$value');
}

class AccActivationKeys {
  final codeInput = const _AccActivationKey('codeInput');
}

class _ResetPassKey extends ValueKey<String> {
  const _ResetPassKey(String value) : super('resetPass_$value');
}

class ResetPassKeys {
  final changePasswordButton = const _ResetPassKey('changePasswordButton');
  final newPasswordInput = const _ResetPassKey('newPasswordInput');
  final phoneInput = const _ResetPassKey('phoneInput');
  final repeatPasswordInput = const _ResetPassKey('repeatPasswordInput');
  final sendCodeButton = const _ResetPassKey('sendCodeButton');
  final smsCodeInput = const _ResetPassKey('smsCodeInput');
}
