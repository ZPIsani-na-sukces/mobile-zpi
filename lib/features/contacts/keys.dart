import 'package:flutter/widgets.dart';

class _ContactsKey extends ValueKey<String> {
  const _ContactsKey(String value) : super('contacts_$value');
}

class ContactsKeys {
  ValueKey<String> contactTile(String contactId) =>
      _ContactsKey('contactTile_$contactId');
}

class _ContactDetailsKey extends ValueKey<String> {
  const _ContactDetailsKey(String value) : super('contactDetails_$value');
}

class ContactDetailsKeys {
  final page = const _ContactDetailsKey('page');
}
