import 'package:flutter/widgets.dart';

class _GeozoneKey extends ValueKey<String> {
  const _GeozoneKey(String value) : super('geozone_$value');
}

class GeozoneKeys {
  final backButton = const _GeozoneKey('backButton');
  final page = const _GeozoneKey('page');
}
