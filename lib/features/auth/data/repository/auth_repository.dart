import 'package:mobile_zpi/config/app_env.dart';
import 'package:mobile_zpi/features/auth/data/models/auth_session.dart';
import 'package:mobile_zpi/features/auth/data/repository/api_auth_repository.dart';
import 'package:mobile_zpi/features/auth/data/repository/mock_auth_repository.dart';
import 'package:mobile_zpi/network/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class InvalidCredentialsException implements Exception {
  const InvalidCredentialsException();
}

abstract interface class AuthRepository {
  Future<AuthSession> login(String identifier, String password);
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  if (AppEnv.useMocks) return MockAuthRepository();
  return ApiAuthRepository(ref.watch(dioProvider));
}
