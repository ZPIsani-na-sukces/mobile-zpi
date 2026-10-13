import 'package:mobile_zpi/features/routine/data/models/routine_task.dart';

String routineTypeLabel(String type) {
  return switch (type) {
    'medication' => 'Lek',
    'meal' => 'Posiłek',
    'hydration' => 'Nawodnienie',
    _ => type,
  };
}

String formatSchedule(RoutineSchedule schedule) {
  const days = ['pon', 'wt', 'śr', 'czw', 'pt', 'sob', 'nd'];
  final sorted = [...schedule.daysOfWeek]..sort();
  final dayText = sorted.length == 7
      ? 'Codziennie'
      : sorted
            .where((day) => day >= 1 && day <= 7)
            .map((day) => days[day - 1])
            .join(', ');
  final times = schedule.times
      .map((time) => time.length >= 5 ? time.substring(0, 5) : time)
      .join(', ');
  return '$dayText · $times';
}

String formatClock(DateTime value) {
  final local = value.toLocal();
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

String occurrenceStatusLabel(String status) {
  return switch (status) {
    'confirmed' => 'Wykonane',
    'skipped' => 'Pominięte',
    'missed' => 'Minęło',
    'cancelled' => 'Anulowane',
    _ => '',
  };
}
