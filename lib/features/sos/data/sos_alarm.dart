/// Result of pressing SOS. While the senior has an unresolved incident, the
/// API adds the new press to it instead of opening another one, and the
/// caretaker is not notified again.
class SosAlarm {
  const SosAlarm({required this.isNew, required this.occurredAt});

  final bool isNew;

  /// When the incident this press belongs to started.
  final DateTime occurredAt;

  /// Short status for the SOS screen and widget.
  String get status => isNew
      ? 'Wysłano o ${_time(occurredAt)}'
      : 'Wezwanie trwa od ${_dateTime(occurredAt)}';
}

String _time(DateTime at) {
  final local = at.toLocal();
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

String _dateTime(DateTime at) {
  final local = at.toLocal();
  final now = DateTime.now();
  final today =
      local.year == now.year &&
      local.month == now.month &&
      local.day == now.day;
  if (today) return _time(local);
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  return '$day.$month, ${_time(local)}';
}
