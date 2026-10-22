String formatDistance(double meters) {
  if (meters < 1000) return '${meters.round()} m';
  final kilometers = (meters / 1000).toStringAsFixed(1).replaceAll('.', ',');
  return '$kilometers km';
}

String formatWalkingDuration(double seconds) {
  final minutes = (seconds / 60).round();
  if (minutes < 1) return 'mniej niż 1 min';
  if (minutes < 60) return 'ok. $minutes min';
  final hours = minutes ~/ 60;
  final rest = minutes % 60;
  return rest == 0 ? 'ok. $hours godz.' : 'ok. $hours godz. $rest min';
}
