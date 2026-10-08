import 'package:mobile_zpi/config/app_env.dart';
import 'package:mobile_zpi/features/auth/data/models/auth_session.dart';
import 'package:mobile_zpi/features/auth/data/models/register_request.dart';
import 'package:mobile_zpi/features/auth/data/models/register_response.dart';
import 'package:mobile_zpi/features/auth/data/repository/api_auth_repository.dart';
import 'package:mobile_zpi/features/auth/data/repository/mock_auth_repository.dart';
import 'package:mobile_zpi/network/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class InvalidCredentialsException implements Exception {
  const InvalidCredentialsException();
}

class AccountAlreadyExistsException implements Exception {
  const AccountAlreadyExistsException();
}

class TooManyAttemptsException implements Exception {
  const TooManyAttemptsException();
}

abstract interface class AuthRepository {
  Future<AuthSession> login(String identifier, String password);
  Future<RegisterResponse> register(RegisterRequest request);
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  if (AppEnv.useMocks) return MockAuthRepository();
  return ApiAuthRepository(ref.watch(dioProvider));
}
