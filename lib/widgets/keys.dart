import 'package:flutter/widgets.dart';

class _WidgetKey extends ValueKey<String> {
  const _WidgetKey(String value) : super('widget_$value');
}

class WidgetKeys {
  final navHome = const _WidgetKey('navHome');
  final navProfile = const _WidgetKey('navProfile');
}
