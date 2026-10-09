import 'package:mobile_zpi/config/app_env.dart';
import 'package:mobile_zpi/features/auth/acc_activation/models/activate_acc_request.dart';
import 'package:mobile_zpi/features/auth/pass_reset/models/set_new_pass_request.dart';
import 'package:mobile_zpi/features/auth/register/models/register_request.dart';
import 'package:mobile_zpi/features/auth/register/models/register_response.dart';
import 'package:mobile_zpi/features/auth/shared/data/api_auth_repository.dart';
import 'package:mobile_zpi/features/auth/shared/data/mock_auth_repository.dart';
import 'package:mobile_zpi/features/auth/shared/data/models/auth_session.dart';
import 'package:mobile_zpi/features/auth/shared/data/models/phone_challenge.dart';
import 'package:mobile_zpi/network/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

abstract interface class AuthRepository {
  Future<AuthSession> login(String identifier, String password);
  Future<RegisterResponse> register(RegisterRequest request);
  Future<PhoneChallenge> sendActivationCode(String verificationTicket);
  Future<void> activateAccount(ActivateAccRequest request);
  Future<PhoneChallenge> sendResetCode(String phoneNumber);
  Future<void> setNewPassword(SetNewPassRequest request);
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  if (AppEnv.useMocks) return MockAuthRepository();
  return ApiAuthRepository(ref.watch(publicDioProvider));
}
