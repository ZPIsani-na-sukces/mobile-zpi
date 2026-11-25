import 'package:dio/dio.dart';
import 'package:mobile_zpi/features/auth/shared/data/auth_exceptions.dart';
import 'package:mobile_zpi/features/auth/shared/data/models/phone_challenge.dart';
import 'package:mobile_zpi/features/profile/data/models/accessibility_preferences.dart';
import 'package:mobile_zpi/features/profile/data/models/account.dart';
import 'package:mobile_zpi/features/profile/data/models/contact_channel.dart';
import 'package:mobile_zpi/features/profile/data/models/detected_address.dart';
import 'package:mobile_zpi/features/profile/data/models/home_address.dart';
import 'package:mobile_zpi/features/profile/data/repository/profile_repository.dart';
import 'package:mobile_zpi/network/dio_problem.dart';

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
  Future<PhoneChallenge> startContactChange(
    ContactChannel channel,
    String value,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/me/profile/${_contactPath(channel)}/change-requests',
        data: switch (channel) {
          ContactChannel.phone => {'phoneNumber': value},
          ContactChannel.email => {'email': value},
        },
      );
      return PhoneChallenge.fromJson(response.data!);
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 400
            when channel == ContactChannel.phone &&
                e.problemCode == 'validationFailed':
          throw const InvalidPhoneNumberException();
        case 409:
          throw const AccountAlreadyExistsException();
        case 429:
          throw TooManyAttemptsException(retryAfter: e.retryAfter);
      }
      rethrow;
    }
  }

  @override
  Future<Account> confirmContactChange({
    required ContactChannel channel,
    required int version,
    required String challengeId,
    required String code,
  }) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '/me/profile/${_contactPath(channel)}',
        data: {'challengeId': challengeId, 'code': code},
        options: Options(headers: {'If-Match': '"$version"'}),
      );
      return Account.fromJson(response.data!);
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 400 when e.problemCode == 'invalidCode':
          throw const InvalidCodeException();
        case 409:
          throw const AccountAlreadyExistsException();
        case 429:
          throw TooManyAttemptsException(retryAfter: e.retryAfter);
      }
      rethrow;
    }
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

  String _contactPath(ContactChannel channel) => switch (channel) {
    ContactChannel.phone => 'phone-number',
    ContactChannel.email => 'email',
  };
}
