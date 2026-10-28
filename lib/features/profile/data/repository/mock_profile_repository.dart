import 'package:mobile_zpi/features/profile/data/models/account.dart';
import 'package:mobile_zpi/features/profile/data/models/detected_address.dart';
import 'package:mobile_zpi/features/profile/data/models/home_address.dart';
import 'package:mobile_zpi/features/profile/data/repository/profile_repository.dart';

class MockProfileRepository implements ProfileRepository {
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
    postalCode: '50-370',
    city: 'Wrocław',
    street: 'Wybrzeże Stanisława Wyspiańskiego',
    buildingNumber: '27',
    coordinates: const Coordinates(latitude: 51.10745, longitude: 17.06200),
    seniorId: '11111111-1111-4111-8111-111111111111',
    formattedAddress: 'Wybrzeże Stanisława Wyspiańskiego 27, 50-370 Wrocław',
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

  String _format(HomeAddressInput input) {
    final street = [
      input.street,
      input.buildingNumber,
      if (input.apartmentNumber != null) '/${input.apartmentNumber}',
    ].whereType<String>().where((part) => part.isNotEmpty).join(' ');
    return '$street, ${input.postalCode} ${input.city}';
  }
}
