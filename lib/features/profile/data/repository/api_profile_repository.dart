import 'package:dio/dio.dart';
import 'package:mobile_zpi/features/profile/data/models/accessibility_preferences.dart';
import 'package:mobile_zpi/features/profile/data/models/account.dart';
import 'package:mobile_zpi/features/profile/data/models/detected_address.dart';
import 'package:mobile_zpi/features/profile/data/models/home_address.dart';
import 'package:mobile_zpi/features/profile/data/repository/profile_repository.dart';

class ApiProfileRepository implements ProfileRepository {
  ApiProfileRepository(this._dio);

  final Dio _dio;

  @override
  Future<Account> getAccount() async {
    final response = await _dio.get<Map<String, dynamic>>('/me');
    return Account.fromJson(response.data!);
  }

  @override
  Future<Account> updateAccount({
    required int version,
    required String firstName,
    required String lastName,
  }) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '/me/profile',
      data: {'firstName': firstName, 'lastName': lastName},
      options: Options(headers: {'If-Match': '"$version"'}),
    );
    return Account.fromJson(response.data!);
  }

  @override
  Future<HomeAddress?> getHomeAddress(String seniorId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/seniors/$seniorId/home-address',
      );
      return HomeAddress.fromJson(response.data!);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  @override
  Future<HomeAddress> saveHomeAddress({
    required String seniorId,
    required int? version,
    required HomeAddressInput input,
  }) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '/seniors/$seniorId/home-address',
      data: input.toJson(),
      options: Options(
        headers: {
          if (version == null) 'If-None-Match': '*',
          if (version != null) 'If-Match': '"$version"',
        },
      ),
    );
    return HomeAddress.fromJson(response.data!);
  }

  @override
  Future<DetectedAddress> detectHomeAddress({
    required String seniorId,
    required double latitude,
    required double longitude,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/seniors/$seniorId/home-address/detect',
      data: {'latitude': latitude, 'longitude': longitude},
    );
    return DetectedAddress.fromJson(response.data!);
  }

  @override
  Future<AccessibilityPreferences> getAccessibilityPreferences(
    String seniorId,
  ) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/seniors/$seniorId/accessibility-preferences',
    );
    return AccessibilityPreferences.fromJson(response.data!);
  }

  @override
  Future<AccessibilityPreferences> saveAccessibilityPreferences(
    AccessibilityPreferences preferences,
  ) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '/seniors/${preferences.seniorId}/accessibility-preferences',
      data: {
        'fontScalePercent': preferences.fontScalePercent,
        'highContrastEnabled': preferences.highContrastEnabled,
        'largeButtonsEnabled': preferences.largeButtonsEnabled,
      },
      options: Options(headers: {'If-Match': '"${preferences.version}"'}),
    );
    return AccessibilityPreferences.fromJson(response.data!);
  }
}
