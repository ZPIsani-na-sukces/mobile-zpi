import 'package:dio/dio.dart';
import 'package:mobile_zpi/features/contacts/data/models/contact.dart';
import 'package:mobile_zpi/features/contacts/data/repository/contacts_repository.dart';

class ApiContactsRepository implements ContactsRepository {
  ApiContactsRepository(this._dio);

  final Dio _dio;

  String _contactsPath(String seniorId) => '/seniors/$seniorId/contacts';

  @override
  Future<List<Contact>> getContacts(String seniorId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      _contactsPath(seniorId),
      queryParameters: {'limit': 100},
    );
    final items = response.data!['items'] as List<dynamic>;
    return items
        .map((e) => Contact.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addContact(String seniorId, Contact contact) =>
      _dio.post<void>(_contactsPath(seniorId), data: contact.toJson());
}
