import 'package:mobile_zpi/features/contacts/data/models/contact.dart';
import 'package:mobile_zpi/features/contacts/data/repository/contacts_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contacts_controller.g.dart';

@riverpod
class ContactsController extends _$ContactsController {
  @override
  Future<List<Contact>> build(String seniorId) =>
      ref.watch(contactsRepositoryProvider).getContacts(seniorId);

  Future<void> addContact(Contact contact) async {
    await ref.read(contactsRepositoryProvider).addContact(seniorId, contact);
    ref.invalidateSelf();
  }
}
