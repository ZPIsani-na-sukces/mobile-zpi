import 'package:mobile_zpi/features/auth/data/models/auth_session.dart';
import 'package:mobile_zpi/features/auth/data/models/auth_user.dart';
import 'package:mobile_zpi/features/auth/data/repository/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  static const _delay = Duration(milliseconds: 500);

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
}
