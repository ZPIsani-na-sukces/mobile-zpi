import 'package:freezed_annotation/freezed_annotation.dart';

part 'routine_task.freezed.dart';
part 'routine_task.g.dart';

@freezed
abstract class RoutineSchedule with _$RoutineSchedule {
  const factory RoutineSchedule({
    required String timeZone,
    required List<int> daysOfWeek,
    required List<String> times,
  }) = _RoutineSchedule;

  factory RoutineSchedule.fromJson(Map<String, dynamic> json) =>
      _$RoutineScheduleFromJson(json);
}

@freezed
abstract class RoutineTask with _$RoutineTask {
  const factory RoutineTask({
    required String taskId,
    required String title,
    required String type,
    required String instructions,
    required bool isActive,
    required String startsOn,
    String? endsOn,
    required RoutineSchedule schedule,
  }) = _RoutineTask;

  factory RoutineTask.fromJson(Map<String, dynamic> json) =>
      _$RoutineTaskFromJson(json);
}
