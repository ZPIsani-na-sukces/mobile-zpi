class RoutineTaskDraft {
  const RoutineTaskDraft({
    required this.type,
    required this.title,
    required this.instructions,
    required this.startsOn,
    required this.endsOn,
    required this.daysOfWeek,
    required this.times,
  });

  final String type;
  final String title;
  final String instructions;
  final DateTime startsOn;
  final DateTime? endsOn;
  final List<int> daysOfWeek;
  final List<String> times;

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'instructions': instructions,
      'startsOn': _date(startsOn),
      'endsOn': endsOn == null ? null : _date(endsOn!),
      'isActive': true,
      'schedule': {
        'timeZone': 'Europe/Warsaw',
        'daysOfWeek': daysOfWeek,
        'times': times,
      },
    };
  }

  static String _date(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }
}
