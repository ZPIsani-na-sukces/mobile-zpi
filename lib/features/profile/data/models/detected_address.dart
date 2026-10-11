import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_zpi/features/profile/data/models/home_address.dart';

part 'detected_address.freezed.dart';
part 'detected_address.g.dart';

@freezed
abstract class GeocodedAddress with _$GeocodedAddress {
  const factory GeocodedAddress({
    String? road,
    String? houseNumber,
    String? postcode,
    String? city,
    String? town,
    String? village,
    String? state,
    String? country,
    String? countryCode,
  }) = _GeocodedAddress;

  factory GeocodedAddress.fromJson(Map<String, dynamic> json) =>
      _$GeocodedAddressFromJson(json);
}

@freezed
abstract class DetectedAddress with _$DetectedAddress {
  const factory DetectedAddress({
    required String displayName,
    required Coordinates coordinates,
    required GeocodedAddress address,
  }) = _DetectedAddress;

  factory DetectedAddress.fromJson(Map<String, dynamic> json) =>
      _$DetectedAddressFromJson(json);
}
