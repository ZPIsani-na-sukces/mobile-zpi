import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_address.freezed.dart';
part 'home_address.g.dart';

@freezed
abstract class Coordinates with _$Coordinates {
  const factory Coordinates({
    required double latitude,
    required double longitude,
  }) = _Coordinates;

  factory Coordinates.fromJson(Map<String, dynamic> json) =>
      _$CoordinatesFromJson(json);
}

@freezed
abstract class HomeAddress with _$HomeAddress {
  const factory HomeAddress({
    required String countryCode,
    required String postalCode,
    required String city,
    String? street,
    required String buildingNumber,
    String? apartmentNumber,
    required Coordinates coordinates,
    required String seniorId,
    required String formattedAddress,
    required DateTime updatedAt,
    required int version,
  }) = _HomeAddress;

  factory HomeAddress.fromJson(Map<String, dynamic> json) =>
      _$HomeAddressFromJson(json);
}

@freezed
abstract class HomeAddressInput with _$HomeAddressInput {
  const factory HomeAddressInput({
    required String countryCode,
    required String postalCode,
    required String city,
    String? street,
    required String buildingNumber,
    String? apartmentNumber,
    required Coordinates coordinates,
  }) = _HomeAddressInput;

  factory HomeAddressInput.fromJson(Map<String, dynamic> json) =>
      _$HomeAddressInputFromJson(json);
}
