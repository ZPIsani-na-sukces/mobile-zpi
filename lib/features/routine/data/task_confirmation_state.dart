import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_zpi/features/routine/data/models/task_occurrence.dart';

part 'task_confirmation_state.freezed.dart';

@freezed
abstract class TaskConfirmationState with _$TaskConfirmationState {
  const factory TaskConfirmationState({
    required List<TaskOccurrence> items,
    @Default(false) bool submitting,
    String? error,
  }) = _TaskConfirmationState;
}
