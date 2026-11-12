import 'package:flutter/material.dart';
import 'package:mobile_zpi/features/routine/data/models/routine_task.dart';
import 'package:mobile_zpi/utils/date_format.dart';

String routineTypeLabel(String type) {
  return switch (type) {
    'medication' => 'Lek',
    'meal' => 'Posiłek',
    'hydration' => 'Nawodnienie',
    _ => type,
  };
}

IconData routineTypeIcon(String type) {
  return switch (type) {
    'medication' => Icons.medication_outlined,
    'meal' => Icons.restaurant,
    'hydration' => Icons.water_drop_outlined,
    _ => Icons.event_note_outlined,
  };
}

const _daysPlural = [
  'poniedziałki',
  'wtorki',
  'środy',
  'czwartki',
  'piątki',
  'soboty',
  'niedziele',
];

const _daysGenitive = [
  'poniedziałku',
  'wtorku',
  'środy',
  'czwartku',
  'piątku',
  'soboty',
  'niedzieli',
];

String formatDays(List<int> daysOfWeek) {
  final days = daysOfWeek.where((day) => day >= 1 && day <= 7).toSet().toList()
    ..sort();
  if (days.isEmpty) return '';
  if (days.length == 7) return 'Codziennie';
  if (days.length >= 3 && days.last - days.first == days.length - 1) {
    return 'Od ${_daysGenitive[days.first - 1]} '
        'do ${_daysGenitive[days.last - 1]}';
  }
  final names = _joinWithAnd([for (final day in days) _daysPlural[day - 1]]);
  return days.first == 2 ? 'We $names' : 'W $names';
}

String formatTimes(List<String> times) {
  final clocks = [
    for (final time in times) time.length >= 5 ? time.substring(0, 5) : time,
  ]..sort();
  return _joinWithAnd(clocks);
}

String formatSchedule(RoutineSchedule schedule) {
  return '${formatDays(schedule.daysOfWeek)} o ${formatTimes(schedule.times)}';
}

String _joinWithAnd(List<String> items) {
  if (items.length < 2) return items.join();
  return '${items.sublist(0, items.length - 1).join(', ')} i ${items.last}';
}

String formatValidity(String startsOn, String? endsOn) {
  final start = formatLongDate(startsOn);
  if (endsOn == null) return 'Od $start';
  return '$start – ${formatLongDate(endsOn)}';
}

String formatClock(DateTime value) {
  final local = value.toLocal();
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

String occurrenceStatusLabel(String status) {
  return switch (status) {
    'pending' => 'Do zrobienia',
    'confirmed' => 'Wykonane',
    'skipped' => 'Pominięte',
    'missed' => 'Minęło',
    'cancelled' => 'Anulowane',
    _ => '',
  };
}
