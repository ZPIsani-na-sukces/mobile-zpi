import 'package:mobile_zpi/config/app_env.dart';
import 'package:mobile_zpi/features/auth/data/models/auth_session.dart';
import 'package:mobile_zpi/features/auth/data/models/new_password_request.dart';
import 'package:mobile_zpi/features/auth/data/models/phone_challenge.dart';
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

class InvalidCodeException implements Exception {
  const InvalidCodeException();
}

class CodeExpiredException implements Exception {
  const CodeExpiredException();
}

abstract interface class AuthRepository {
  Future<AuthSession> login(String identifier, String password);
  Future<RegisterResponse> register(RegisterRequest request);
  Future<PhoneChallenge> sendResetCode(String phoneNumber);
  Future<void> setNewPassword(NewPasswordRequest request);
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  if (AppEnv.useMocks) return MockAuthRepository();
  return ApiAuthRepository(ref.watch(dioProvider));
}
