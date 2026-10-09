abstract final class AuthValidators {
  static const int _nameMaxLength = 100;
  static const int _emailMaxLength = 254;
  static const int _passwordMinLength = 12;
  static const int _passwordMaxLength = 128;
  static const String _defaultCountryCode = '+48';
  static const int _verificationCodeLength = 6;

  static final _e164 = RegExp(r'^\+[1-9][0-9]{1,14}$');
  static final _localPhone = RegExp(r'^[0-9]{9}$');
  static final _phoneSeparators = RegExp(r'[\s\-()]');
  static final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _verificationCode = RegExp('^[0-9]{$_verificationCodeLength}\$');

  static String? firstName(String value) =>
      _name(value, empty: 'Wpisz imię', tooLong: 'Imię jest za długie');

  static String? lastName(String value) =>
      _name(value, empty: 'Wpisz nazwisko', tooLong: 'Nazwisko jest za długie');

  static String? phoneNumber(String value) {
    if (value.trim().isEmpty) return 'Wpisz numer telefonu';
    if (normalizePhoneNumber(value) == null) {
      return 'Wpisz 9-cyfrowy numer telefonu, np. 600 123 456';
    }
    return null;
  }

  static String? email(String value) {
    final email = value.trim();
    if (email.isEmpty) return null;
    if (email.length > _emailMaxLength || !_email.hasMatch(email)) {
      return 'Nieprawidłowy adres e-mail';
    }
    return null;
  }

  static String? password(String value) {
    if (value.isEmpty) return 'Wpisz hasło';
    if (value.length < _passwordMinLength) {
      return 'Hasło musi mieć co najmniej $_passwordMinLength znaków';
    }
    if (value.length > _passwordMaxLength) {
      return 'Hasło może mieć maksymalnie $_passwordMaxLength znaków';
    }
    return null;
  }

  static String? repeatPassword(String value, String password) {
    if (value.isEmpty) return 'Powtórz hasło';
    if (value != password) return 'Hasła nie są takie same';
    return null;
  }

  static String? verificationCode(String value) {
    if (value.isEmpty) return 'Wpisz kod z SMS';
    if (!_verificationCode.hasMatch(value)) {
      return 'Kod ma $_verificationCodeLength cyfr';
    }
    return null;
  }

  static String? normalizePhoneNumber(String value) {
    var phone = value.replaceAll(_phoneSeparators, '');
    if (phone.startsWith('00')) {
      phone = '+${phone.substring(2)}';
    } else if (!phone.startsWith('+')) {
      if (!_localPhone.hasMatch(phone)) return null;
      phone = '$_defaultCountryCode$phone';
    }
    return _e164.hasMatch(phone) ? phone : null;
  }

  static String? normalizeEmail(String value) {
    final email = value.trim();
    return email.isEmpty ? null : email;
  }

  static String? _name(
    String value, {
    required String empty,
    required String tooLong,
  }) {
    final name = value.trim();
    if (name.isEmpty) return empty;
    if (name.length > _nameMaxLength) return tooLong;
    return null;
  }
}
