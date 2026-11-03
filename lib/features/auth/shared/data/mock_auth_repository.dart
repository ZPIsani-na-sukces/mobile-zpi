import 'package:mobile_zpi/features/auth/acc_activation/models/activate_acc_request.dart';
import 'package:mobile_zpi/features/auth/pass_reset/models/set_new_pass_request.dart';
import 'package:mobile_zpi/features/auth/pass_reset/models/verify_reset_pass_code_request.dart';
import 'package:mobile_zpi/features/auth/register/models/register_request.dart';
import 'package:mobile_zpi/features/auth/register/models/register_response.dart';
import 'package:mobile_zpi/features/auth/shared/data/auth_exceptions.dart';
import 'package:mobile_zpi/features/auth/shared/data/auth_repository.dart';
import 'package:mobile_zpi/features/auth/shared/data/models/auth_session.dart';
import 'package:mobile_zpi/features/auth/shared/data/models/auth_user.dart';
import 'package:mobile_zpi/features/auth/shared/data/models/phone_challenge.dart';

class MockAuthRepository implements AuthRepository {
  static const _delay = Duration(milliseconds: 500);

  var _resetChallengeCount = 0;
  var _verificationChallengeCount = 0;
  var _phoneVerified = false;

  @override
  Future<AuthSession> login(String identifier, String password) async {
    await Future<void>.delayed(_delay);
    if (password == 'wrong') throw const InvalidCredentialsException();
    if (password.startsWith('unverified') && !_phoneVerified) {
      throw PhoneVerificationRequiredException(
        verificationTicket: 'mock-verification-ticket',
        phoneChallenge: password == 'unverified-pending'
            ? PhoneChallenge(
                challengeId: 'mock-pending-challenge',
                resendAfter: DateTime.now().add(const Duration(seconds: 30)),
              )
            : null,
      );
    }

    return const AuthSession(
      accessToken: 'mock-access-token',
      refreshToken: 'mock-refresh-token',
      user: AuthUser(
        userId: 'senior-1',
        firstName: 'Stanisław',
        lastName: 'Kowalski',
        role: 'SENIOR',
      ),
    );
  }

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    await Future<void>.delayed(_delay);
    if (request.phoneNumber == '+48600000000') {
      throw const AccountAlreadyExistsException();
    }
    final now = DateTime.now();

    return RegisterResponse(
      userId: 'senior-1',
      verificationTicket: 'mock-verification-ticket',
      ticketExpiresAt: now.add(const Duration(minutes: 30)),
      phoneChallenge: PhoneChallenge(
        challengeId: 'mock-challenge-1',
        resendAfter: now.add(const Duration(seconds: 30)),
      ),
    );
  }

  @override
  Future<PhoneChallenge> sendActivationCode(String verificationTicket) async {
    await Future<void>.delayed(_delay);

    _verificationChallengeCount++;
    return PhoneChallenge(
      challengeId: 'mock-verification-challenge-$_verificationChallengeCount',
      resendAfter: DateTime.now().add(const Duration(seconds: 60)),
    );
  }

  @override
  Future<void> activateAccount(ActivateAccRequest request) async {
    await Future<void>.delayed(_delay);
    switch (request.code) {
      case '123456':
        _phoneVerified = true;
      case '000000':
        throw const CodeExpiredException();
      default:
        throw const InvalidCodeException();
    }
  }

  @override
  Future<PhoneChallenge> sendResetCode(String phoneNumber) async {
    await Future<void>.delayed(_delay);
    if (phoneNumber == '+48600000000') throw const TooManyAttemptsException();

    _resetChallengeCount++;
    return PhoneChallenge(
      challengeId: 'mock-reset-challenge-$_resetChallengeCount',
      resendAfter: DateTime.now().add(const Duration(seconds: 60)),
    );
  }

  @override
  Future<void> verifyResetCode(VerifyResetPassCodeRequest request) async {
    await Future<void>.delayed(_delay);
    switch (request.code) {
      case '123456':
        return;
      case '000000':
        throw const CodeExpiredException();
      default:
        throw const InvalidCodeException();
    }
  }

  @override
  Future<void> setNewPassword(SetNewPassRequest request) async {
    await Future<void>.delayed(_delay);
    switch (request.code) {
      case '123456':
        return;
      case '000000':
        throw const CodeExpiredException();
      default:
        throw const InvalidCodeException();
    }
  }

  @override
  Future<AuthSession> refresh(String refreshToken) async =>
      throw const SessionExpiredException();

  @override
  Future<void> logout(AuthSession session) => Future<void>.delayed(_delay);
}
