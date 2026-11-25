import 'package:dio/dio.dart';
import 'package:mobile_zpi/features/auth/acc_activation/models/activate_acc_request.dart';
import 'package:mobile_zpi/features/auth/acc_activation/models/send_acc_activation_code_request.dart';
import 'package:mobile_zpi/features/auth/login/models/login_request.dart';
import 'package:mobile_zpi/features/auth/pass_reset/models/reset_channel.dart';
import 'package:mobile_zpi/features/auth/pass_reset/models/send_reset_pass_code_request.dart';
import 'package:mobile_zpi/features/auth/pass_reset/models/set_new_pass_request.dart';
import 'package:mobile_zpi/features/auth/pass_reset/models/verify_reset_pass_code_request.dart';
import 'package:mobile_zpi/features/auth/register/models/register_request.dart';
import 'package:mobile_zpi/features/auth/register/models/register_response.dart';
import 'package:mobile_zpi/features/auth/shared/data/auth_exceptions.dart';
import 'package:mobile_zpi/features/auth/shared/data/auth_repository.dart';
import 'package:mobile_zpi/features/auth/shared/data/models/auth_session.dart';
import 'package:mobile_zpi/features/auth/shared/data/models/phone_challenge.dart';
import 'package:mobile_zpi/network/dio_problem.dart';

class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository(this._dio);

  final Dio _dio;

  @override
  Future<AuthSession> login(String identifier, String password) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: LoginRequest(identifier: identifier, password: password).toJson(),
      );
      return AuthSession.fromJson(response.data!);
    } on DioException catch (e) {
      switch (e.response) {
        case Response(statusCode: 401):
          throw const InvalidCredentialsException();
        case Response(
          statusCode: 403,
          data: {
            'code': 'phoneVerificationRequired',
            'verificationTicket': final String verificationTicket,
          },
        ):
          throw PhoneVerificationRequiredException(
            verificationTicket: verificationTicket,
            phoneChallenge: _phoneChallenge(e),
          );
        case Response(statusCode: 403, data: {'code': 'operationForbidden'}):
          throw const AccountUnavailableException();
        case Response(statusCode: 429):
          throw TooManyAttemptsException(retryAfter: e.retryAfter);
      }
      rethrow;
    }
  }

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/registrations',
        data: request.toJson(),
      );
      return RegisterResponse.fromJson(response.data!);
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 409:
          throw const AccountAlreadyExistsException();
        case 429:
          throw const TooManyAttemptsException();
      }
      rethrow;
    }
  }

  @override
  Future<PhoneChallenge> sendActivationCode(String verificationTicket) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/phone-verifications',
        data: SendAccActivationCodeRequest(
          verificationTicket: verificationTicket,
        ).toJson(),
      );
      return PhoneChallenge.fromJson(response.data!);
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 400 || 409:
          throw const VerificationExpiredException();
        case 429:
          throw TooManyAttemptsException(retryAfter: e.retryAfter);
      }
      rethrow;
    }
  }

  @override
  Future<void> activateAccount(ActivateAccRequest request) async {
    try {
      await _dio.post<void>(
        '/auth/phone-verifications/confirm',
        data: request.toJson(),
      );
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 400 when e.problemCode == 'invalidCode':
          throw const InvalidCodeException();
        case 409:
          throw const CodeExpiredException();
        case 429:
          throw TooManyAttemptsException(retryAfter: e.retryAfter);
      }
      rethrow;
    }
  }

  @override
  Future<PhoneChallenge> sendResetCode(
    ResetChannel channel,
    String identifier,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/password-reset-requests',
        data: SendResetPassCodeRequest(
          channel: channel,
          identifier: identifier,
        ).toJson(),
      );
      return PhoneChallenge.fromJson(response.data!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        throw const TooManyAttemptsException();
      }
      rethrow;
    }
  }

  @override
  Future<void> verifyResetCode(VerifyResetPassCodeRequest request) async {
    try {
      await _dio.post<void>(
        '/auth/password-resets/verify',
        data: request.toJson(),
      );
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 400 when e.problemCode == 'invalidCode':
          throw const InvalidCodeException();
        case 429:
          throw TooManyAttemptsException(retryAfter: e.retryAfter);
      }
      rethrow;
    }
  }

  @override
  Future<void> setNewPassword(SetNewPassRequest request) async {
    try {
      await _dio.post<void>('/auth/password-resets', data: request.toJson());
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 400 when e.problemCode == 'invalidCode':
          throw const InvalidCodeException();
        case 409:
          throw const CodeExpiredException();
        case 429:
          throw const TooManyAttemptsException();
      }
      rethrow;
    }
  }

  @override
  Future<AuthSession> refresh(String refreshToken) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'clientType': 'mobile', 'refreshToken': refreshToken},
      );
      return AuthSession.fromJson(response.data!);
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 401 || 403:
          throw const SessionExpiredException();
      }
      rethrow;
    }
  }

  @override
  Future<void> logout(AuthSession session) async {
    try {
      await _logout(session.accessToken);
    } on DioException catch (e) {
      if (e.response?.statusCode != 401) rethrow;
      final renewed = await refresh(session.refreshToken);
      await _logout(renewed.accessToken);
    }
  }

  Future<void> _logout(String accessToken) => _dio.post<void>(
    '/auth/logout',
    options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
  );

  PhoneChallenge? _phoneChallenge(DioException e) {
    if (e.response?.data case {
      'phoneChallenge': final Map<String, dynamic> json,
    }) {
      try {
        return PhoneChallenge.fromJson(json);
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
