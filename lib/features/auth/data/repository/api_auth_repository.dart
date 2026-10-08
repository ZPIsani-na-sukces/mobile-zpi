import 'package:dio/dio.dart';
import 'package:mobile_zpi/features/auth/data/models/auth_session.dart';
import 'package:mobile_zpi/features/auth/data/models/login_request.dart';
import 'package:mobile_zpi/features/auth/data/models/register_request.dart';
import 'package:mobile_zpi/features/auth/data/models/register_response.dart';
import 'package:mobile_zpi/features/auth/data/repository/auth_repository.dart';

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
      if (e.response?.statusCode == 401) {
        throw const InvalidCredentialsException();
      }
      rethrow;
    }
  }

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/register',
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
}
