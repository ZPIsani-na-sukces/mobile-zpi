import 'package:flutter/widgets.dart';

class _RoutineTaskKey extends ValueKey<String> {
  const _RoutineTaskKey(String value) : super('routineTask_$value');
}

class RoutineTaskKeys {
  final page = const _RoutineTaskKey('page');
}
