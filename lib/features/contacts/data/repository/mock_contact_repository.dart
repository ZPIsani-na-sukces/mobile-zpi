import 'package:mobile_zpi/features/contacts/data/models/contact.dart';
import 'package:mobile_zpi/features/contacts/data/repository/contacts_repository.dart';

class MockContactsRepository implements ContactsRepository {
  static const _creator = ContactCreator(
    userId: 'caregiver-1',
    firstName: 'Katarzyna',
    lastName: 'Wiśniewska',
    role: 'CAREGIVER',
  );

  final _contacts = <Contact>[
    Contact(
      contactId: '1',
      seniorId: '',
      displayName: 'Anna',
      firstName: 'Anna',
      lastName: 'Kowalska',
      relationshipLabel: 'Córka',
      phoneNumber: '+48 600 100 200',
      isActive: true,
      createdBy: _creator,
      createdAt: DateTime(2026, 9, 1, 10),
      updatedAt: DateTime(2026, 9, 1, 10),
      version: 1,
    ),
    Contact(
      contactId: '2',
      seniorId: '',
      displayName: 'Jan',
      firstName: 'Jan',
      lastName: 'Nowak',
      relationshipLabel: 'Syn',
      phoneNumber: '+48 600 300 400',
      isActive: true,
      createdBy: _creator,
      createdAt: DateTime(2026, 9, 1, 10, 5),
      updatedAt: DateTime(2026, 9, 3, 14, 20),
      version: 2,
    ),
    Contact(
      contactId: '3',
      seniorId: '',
      displayName: 'Dr Zielińska',
      firstName: 'Ewa',
      lastName: 'Zielińska',
      relationshipLabel: 'Lekarz rodzinny',
      phoneNumber: '+48 22 555 12 34',
      isActive: true,
      createdBy: _creator,
      createdAt: DateTime(2026, 9, 2, 9, 30),
      updatedAt: DateTime(2026, 9, 2, 9, 30),
      version: 1,
    ),
    Contact(
      contactId: '4',
      seniorId: '',
      displayName: 'Pani Halina',
      firstName: 'Halina',
      lastName: 'Lewandowska',
      relationshipLabel: 'Sąsiadka',
      phoneNumber: '+48 501 222 333',
      isActive: true,
      createdBy: _creator,
      createdAt: DateTime(2026, 9, 5, 16, 45),
      updatedAt: DateTime(2026, 9, 5, 16, 45),
      version: 1,
    ),
    Contact(
      contactId: '5',
      seniorId: '',
      displayName: 'Tomek',
      firstName: 'Tomasz',
      lastName: 'Kowalski',
      relationshipLabel: 'Wnuk',
      phoneNumber: '+48 790 444 555',
      isActive: true,
      createdBy: _creator,
      createdAt: DateTime(2026, 9, 10, 18),
      updatedAt: DateTime(2026, 9, 10, 18),
      version: 1,
    ),
  ];

  static const _delay = Duration(milliseconds: 600);

  @override
  Future<List<Contact>> getContacts(String seniorId) async {
    await Future<void>.delayed(_delay);
    return List.unmodifiable(_contacts);
  }

  @override
  Future<void> addContact(String seniorId, Contact contact) async {
    await Future<void>.delayed(_delay);
    _contacts.add(contact);
  }
}
