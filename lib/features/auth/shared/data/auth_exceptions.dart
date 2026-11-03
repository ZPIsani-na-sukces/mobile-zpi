import 'package:mobile_zpi/features/auth/shared/data/models/phone_challenge.dart';

class InvalidCredentialsException implements Exception {
  const InvalidCredentialsException();
}

class AccountAlreadyExistsException implements Exception {
  const AccountAlreadyExistsException();
}

class TooManyAttemptsException implements Exception {
  const TooManyAttemptsException({this.retryAfter});

  final Duration? retryAfter;
}

class InvalidCodeException implements Exception {
  const InvalidCodeException();
}

class CodeExpiredException implements Exception {
  const CodeExpiredException();
}

class PhoneVerificationRequiredException implements Exception {
  const PhoneVerificationRequiredException({
    required this.verificationTicket,
    this.phoneChallenge,
  });

  final String verificationTicket;
  final PhoneChallenge? phoneChallenge;
}

class VerificationExpiredException implements Exception {
  const VerificationExpiredException();
}

class SessionExpiredException implements Exception {
  const SessionExpiredException();
}

class AccountUnavailableException implements Exception {
  const AccountUnavailableException();
}
