import 'package:freezed_annotation/freezed_annotation.dart';

part 'geozone.freezed.dart';
part 'geozone.g.dart';

@freezed
abstract class Geozone with _$Geozone {
  const factory Geozone({
    required String zoneId,
    required String seniorId,
    required String name,
    required GeozoneCenter center,
    required double radiusMeters,
    required bool isActive,
    required bool smsOnExitEnabled,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) = _Geozone;

  factory Geozone.fromJson(Map<String, dynamic> json) =>
      _$GeozoneFromJson(json);
}

@freezed
abstract class GeozoneCenter with _$GeozoneCenter {
  const factory GeozoneCenter({
    required double latitude,
    required double longitude,
  }) = _GeozoneCenter;

  factory GeozoneCenter.fromJson(Map<String, dynamic> json) =>
      _$GeozoneCenterFromJson(json);
}
