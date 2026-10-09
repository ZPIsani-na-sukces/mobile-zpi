import 'package:mobile_zpi/features/auth/data/models/auth_session.dart';
import 'package:mobile_zpi/features/auth/data/models/auth_user.dart';
import 'package:mobile_zpi/features/auth/data/models/new_password_request.dart';
import 'package:mobile_zpi/features/auth/data/models/phone_challenge.dart';
import 'package:mobile_zpi/features/auth/data/models/register_request.dart';
import 'package:mobile_zpi/features/auth/data/models/register_response.dart';
import 'package:mobile_zpi/features/auth/data/repository/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  static const _delay = Duration(milliseconds: 500);

  var _resetChallengeCount = 0;

  @override
  Future<AuthSession> login(String identifier, String password) async {
    await Future<void>.delayed(_delay);
    if (password == 'wrong') throw const InvalidCredentialsException();

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
  Future<void> setNewPassword(NewPasswordRequest request) async {
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
}
