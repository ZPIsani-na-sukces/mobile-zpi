/// Values the tests type in. IDs point at data in the `Mock*Repository`
/// classes, which the app uses with `USE_MOCKS=true`.
abstract final class TestData {
  static const phone = '600123456';
  static const password = 'Haslo1234';
  static const newPassword = 'NoweHaslo1234';
  static const firstName = 'Adam';
  static const lastName = 'Nowak';
  static const email = 'adam.nowak@example.com';
  static const city = 'Kraków';
  static const street = 'Floriańska';

  /// `MockHomeRepository` and `MockContactRepository`: "Anna, Córka".
  static const contactId = '1';

  /// `MockHomeRepository`: "Leki poranne" at 8:00.
  static const taskOccurrenceId = '1';

  /// `MockHomeRepository`: "Dom".
  static const zoneId = '1';

  /// `MockInvitationsRepository`: Katarzyna Wiśniewska.
  static const caretakerRelationshipId = 'relationship-1';

  /// `MockInvitationsRepository`: the caretaker added with the invitation code.
  static const invitedCaretakerRelationshipId = 'relationship-3';
}
