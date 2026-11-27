import 'package:flutter/widgets.dart';

class _HomeKey extends ValueKey<String> {
  const _HomeKey(String value) : super('home_$value');
}

class HomeKeys {
  final allContactsButton = const _HomeKey('allContactsButton');
  ValueKey<String> contactTile(String contactId) =>
      _HomeKey('contactTile_$contactId');
  final page = const _HomeKey('page');
  final sosButton = const _HomeKey('sosButton');
  ValueKey<String> taskTile(String occurrenceId) =>
      _HomeKey('taskTile_$occurrenceId');
  ValueKey<String> zoneTile(String zoneId) => _HomeKey('zoneTile_$zoneId');
}
