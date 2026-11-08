import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_occurrence.freezed.dart';
part 'task_occurrence.g.dart';

@freezed
abstract class TaskOccurrence with _$TaskOccurrence {
  const factory TaskOccurrence({
    required String occurrenceId,
    required String taskId,
    required String title,
    required String instructions,
    required String type,
    required DateTime scheduledAt,
    required String status,

    /// When to remind: 15 minutes before [scheduledAt] and at [scheduledAt].
    @Default([]) List<DateTime> reminderAt,
  }) = _TaskOccurrence;

  factory TaskOccurrence.fromJson(Map<String, dynamic> json) =>
      _$TaskOccurrenceFromJson(json);
}
