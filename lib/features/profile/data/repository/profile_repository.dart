import 'package:mobile_zpi/config/app_env.dart';
import 'package:mobile_zpi/features/profile/data/models/accessibility_preferences.dart';
import 'package:mobile_zpi/features/profile/data/models/account.dart';
import 'package:mobile_zpi/features/profile/data/models/detected_address.dart';
import 'package:mobile_zpi/features/profile/data/models/home_address.dart';
import 'package:mobile_zpi/features/profile/data/repository/api_profile_repository.dart';
import 'package:mobile_zpi/features/profile/data/repository/mock_profile_repository.dart';
import 'package:mobile_zpi/network/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_repository.g.dart';

abstract interface class ProfileRepository {
  Future<Account> getAccount();

  Future<Account> updateAccount({
    required int version,
    required String firstName,
    required String lastName,
  });

  Future<HomeAddress?> getHomeAddress(String seniorId);

  Future<HomeAddress> saveHomeAddress({
    required String seniorId,
    required int? version,
    required HomeAddressInput input,
  });

  Future<DetectedAddress> detectHomeAddress({
    required String seniorId,
    required double latitude,
    required double longitude,
  });

  Future<AccessibilityPreferences> getAccessibilityPreferences(String seniorId);

  Future<AccessibilityPreferences> saveAccessibilityPreferences(
    AccessibilityPreferences preferences,
  );
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) {
  if (AppEnv.useMocks) return MockProfileRepository();
  return ApiProfileRepository(ref.watch(authDioProvider));
}
