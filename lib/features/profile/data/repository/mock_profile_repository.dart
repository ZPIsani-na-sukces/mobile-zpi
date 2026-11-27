import 'package:mobile_zpi/features/auth/shared/data/auth_exceptions.dart';
import 'package:mobile_zpi/features/auth/shared/data/models/phone_challenge.dart';
import 'package:mobile_zpi/features/profile/data/models/accessibility_preferences.dart';
import 'package:mobile_zpi/features/profile/data/models/account.dart';
import 'package:mobile_zpi/features/profile/data/models/contact_channel.dart';
import 'package:mobile_zpi/features/profile/data/models/detected_address.dart';
import 'package:mobile_zpi/features/profile/data/models/home_address.dart';
import 'package:mobile_zpi/features/profile/data/repository/profile_repository.dart';

const mockContactChangeCode = '123456';

class MockProfileRepository implements ProfileRepository {
  final _pendingContactChanges = <String, String>{};

  Account _account = const Account(
    userId: '11111111-1111-4111-8111-111111111111',
    role: 'senior',
    firstName: 'Jan',
    lastName: 'Kowalski',
    phoneNumber: '+48123456789',
    phoneVerified: true,
    emailVerified: false,
    status: 'active',
    version: 1,
  );

  HomeAddress? _address = HomeAddress(
    countryCode: 'PL',
    postalCode: '50-377',
    city: 'Wrocław',
    street: 'plac Grunwaldzki',
    buildingNumber: '13',
    coordinates: const Coordinates(latitude: 51.11028, longitude: 17.05824),
    seniorId: '11111111-1111-4111-8111-111111111111',
    formattedAddress: 'plac Grunwaldzki 13, 50-377 Wrocław',
    updatedAt: DateTime.utc(2026, 9, 27, 8),
    version: 1,
  );

  AccessibilityPreferences _accessibility = AccessibilityPreferences(
    fontScalePercent: 100,
    highContrastEnabled: false,
    largeButtonsEnabled: false,
    seniorId: '11111111-1111-4111-8111-111111111111',
    updatedAt: DateTime.utc(2026, 9, 27, 8),
    version: 1,
  );

  @override
  Future<Account> getAccount() async => _account;

  @override
  Future<Account> updateAccount({
    required int version,
    required String firstName,
    required String lastName,
  }) async {
    _account = _account.copyWith(
      firstName: firstName,
      lastName: lastName,
      version: version + 1,
    );
    return _account;
  }

  @override
  Future<PhoneChallenge> startContactChange(
    ContactChannel channel,
    String value,
  ) async {
    final challengeId =
        'mock-${channel.name}-${DateTime.now().millisecondsSinceEpoch}';
    _pendingContactChanges[challengeId] = value;
    return PhoneChallenge(
      challengeId: challengeId,
      resendAfter: DateTime.now().add(const Duration(seconds: 60)),
    );
  }

  @override
  Future<Account> confirmContactChange({
    required ContactChannel channel,
    required int version,
    required String challengeId,
    required String code,
  }) async {
    final value = _pendingContactChanges[challengeId];
    if (value == null || code != mockContactChangeCode) {
      throw const InvalidCodeException();
    }
    _pendingContactChanges.remove(challengeId);
    _account = switch (channel) {
      ContactChannel.phone => _account.copyWith(
        phoneNumber: value,
        phoneVerified: true,
        version: version + 1,
      ),
      ContactChannel.email => _account.copyWith(
        email: value,
        emailVerified: true,
        version: version + 1,
      ),
    };
    return _account;
  }

  @override
  Future<HomeAddress?> getHomeAddress(String seniorId) async => _address;

  @override
  Future<HomeAddress> saveHomeAddress({
    required String seniorId,
    required int? version,
    required HomeAddressInput input,
  }) async {
    final saved = HomeAddress(
      countryCode: input.countryCode,
      postalCode: input.postalCode,
      city: input.city,
      street: input.street,
      buildingNumber: input.buildingNumber,
      apartmentNumber: input.apartmentNumber,
      coordinates: input.coordinates,
      seniorId: seniorId,
      formattedAddress: _format(input),
      updatedAt: DateTime.now().toUtc(),
      version: (version ?? 0) + 1,
    );
    _address = saved;
    return saved;
  }

  @override
  Future<DetectedAddress> detectHomeAddress({
    required String seniorId,
    required double latitude,
    required double longitude,
  }) async {
    return DetectedAddress(
      displayName: 'Marszałkowska 10, 00-001 Warszawa',
      coordinates: Coordinates(latitude: latitude, longitude: longitude),
      address: const GeocodedAddress(
        road: 'Marszałkowska',
        houseNumber: '10',
        postcode: '00-001',
        city: 'Warszawa',
        country: 'Polska',
        countryCode: 'PL',
      ),
    );
  }

  @override
  Future<AccessibilityPreferences> getAccessibilityPreferences(
    String seniorId,
  ) async => _accessibility;

  @override
  Future<AccessibilityPreferences> saveAccessibilityPreferences(
    AccessibilityPreferences preferences,
  ) async {
    _accessibility = preferences.copyWith(
      updatedAt: DateTime.now().toUtc(),
      version: preferences.version + 1,
    );
    return _accessibility;
  }

  String _format(HomeAddressInput input) {
    final street = [
      input.street,
      input.buildingNumber,
      if (input.apartmentNumber != null) '/${input.apartmentNumber}',
    ].whereType<String>().where((part) => part.isNotEmpty).join(' ');
    return '$street, ${input.postalCode} ${input.city}';
  }
}
