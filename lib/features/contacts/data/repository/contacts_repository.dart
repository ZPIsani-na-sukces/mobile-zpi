import 'package:mobile_zpi/config/app_env.dart';
import 'package:mobile_zpi/features/contacts/data/models/contact.dart';
import 'package:mobile_zpi/features/contacts/data/repository/api_contacts_repository.dart';
import 'package:mobile_zpi/features/contacts/data/repository/mock_contact_repository.dart';
import 'package:mobile_zpi/network/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contacts_repository.g.dart';

abstract interface class ContactsRepository {
  Future<List<Contact>> getContacts(String seniorId);
  Future<void> addContact(String seniorId, Contact contact);
}

@Riverpod(keepAlive: true)
ContactsRepository contactsRepository(Ref ref) {
  if (AppEnv.useMocks) return MockContactsRepository();
  return ApiContactsRepository(ref.watch(authDioProvider));
}
