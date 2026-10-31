import 'package:dio/dio.dart';
import 'package:mobile_zpi/features/auth/acc_activation/models/activate_acc_request.dart';
import 'package:mobile_zpi/features/auth/acc_activation/models/send_acc_activation_code_request.dart';
import 'package:mobile_zpi/features/auth/login/models/login_request.dart';
import 'package:mobile_zpi/features/auth/pass_reset/models/send_reset_pass_code_request.dart';
import 'package:mobile_zpi/features/auth/pass_reset/models/set_new_pass_request.dart';
import 'package:mobile_zpi/features/auth/pass_reset/models/verify_reset_pass_code_request.dart';
import 'package:mobile_zpi/features/auth/register/models/register_request.dart';
import 'package:mobile_zpi/features/auth/register/models/register_response.dart';
import 'package:mobile_zpi/features/auth/shared/data/auth_exceptions.dart';
import 'package:mobile_zpi/features/auth/shared/data/auth_repository.dart';
import 'package:mobile_zpi/features/auth/shared/data/models/auth_session.dart';
import 'package:mobile_zpi/features/auth/shared/data/models/phone_challenge.dart';

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
          throw TooManyAttemptsException(retryAfter: _retryAfter(e));
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
        case 400 when _problemCode(e) == 'invalidCode':
          throw const InvalidCodeException();
        case 409:
          throw const CodeExpiredException();
        case 429:
          throw TooManyAttemptsException(retryAfter: _retryAfter(e));
      }
      rethrow;
    }
  }

  @override
  Future<PhoneChallenge> sendResetCode(String phoneNumber) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/password-reset-requests',
        data: SendResetPassCodeRequest(identifier: phoneNumber).toJson(),
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
        case 400 when _problemCode(e) == 'invalidCode':
          throw const InvalidCodeException();
        case 429:
          throw TooManyAttemptsException(retryAfter: _retryAfter(e));
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
        case 400 when _problemCode(e) == 'invalidCode':
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
  Future<void> logout(String accessToken) async {
    await _dio.post<void>(
      '/auth/logout',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
  }

  String? _problemCode(DioException e) => switch (e.response?.data) {
    {'code': final String code} => code,
    _ => null,
  };

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

  Duration? _retryAfter(DioException e) =>
      switch (int.tryParse(e.response?.headers.value('retry-after') ?? '')) {
        final seconds? => Duration(seconds: seconds),
        null => null,
      };
}
