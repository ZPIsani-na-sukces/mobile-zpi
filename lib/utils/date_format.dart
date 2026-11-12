const _monthsGenitive = [
  'stycznia',
  'lutego',
  'marca',
  'kwietnia',
  'maja',
  'czerwca',
  'lipca',
  'sierpnia',
  'września',
  'października',
  'listopada',
  'grudnia',
];

String formatLongDate(String date) {
  final value = DateTime.tryParse(date);
  if (value == null) return date;
  return '${value.day} ${_monthsGenitive[value.month - 1]} ${value.year}';
}
