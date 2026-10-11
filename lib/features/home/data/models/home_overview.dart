import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_overview.freezed.dart';
part 'home_overview.g.dart';

@freezed
abstract class HomeContact with _$HomeContact {
  const factory HomeContact({
    required String contactId,
    required String displayName,
    String? relationshipLabel,
    required String phoneNumber,
  }) = _HomeContact;

  factory HomeContact.fromJson(Map<String, dynamic> json) =>
      _$HomeContactFromJson(json);
}

@freezed
abstract class UpcomingTask with _$UpcomingTask {
  const factory UpcomingTask({
    required String occurrenceId,
    required String title,
    required DateTime scheduledAt,
    required String status,
  }) = _UpcomingTask;

  factory UpcomingTask.fromJson(Map<String, dynamic> json) =>
      _$UpcomingTaskFromJson(json);
}

@freezed
abstract class HomeZone with _$HomeZone {
  const factory HomeZone({
    required String zoneId,
    required String name,
    required double radiusMeters,
  }) = _HomeZone;

  factory HomeZone.fromJson(Map<String, dynamic> json) =>
      _$HomeZoneFromJson(json);
}

@freezed
abstract class HomeOverview with _$HomeOverview {
  const factory HomeOverview({
    required List<HomeContact> contacts,
    required List<UpcomingTask> tasks,
    required List<HomeZone> zones,
  }) = _HomeOverview;
}
