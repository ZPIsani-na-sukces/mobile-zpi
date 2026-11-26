import 'package:mobile_zpi/features/contacts/data/models/contact.dart';
import 'package:mobile_zpi/features/invitations/data/invitation_exceptions.dart';
import 'package:mobile_zpi/features/invitations/data/models/care_invitation.dart';
import 'package:mobile_zpi/features/invitations/data/repository/invitations_repository.dart';

/// Previews and accepts, any other code is invalid.
const mockInvitationCode = '123456';

class MockInvitationsRepository implements InvitationsRepository {
  final List<CareRelationship> _caretakers = [
    CareRelationship(
      relationshipId: 'relationship-1',
      caretaker: const ContactCreator(
        userId: 'caretaker-1',
        firstName: 'Katarzyna',
        lastName: 'Wiśniewska',
        role: 'caretaker',
      ),
      status: 'active',
      createdAt: DateTime.utc(2026, 10, 1, 9),
    ),
    CareRelationship(
      relationshipId: 'relationship-2',
      caretaker: const ContactCreator(
        userId: 'caretaker-2',
        firstName: 'Tomasz',
        lastName: 'Nowak',
        role: 'caretaker',
      ),
      status: 'active',
      createdAt: DateTime.utc(2026, 10, 12, 14),
    ),
  ];

  CareInvitation? _sent;

  @override
  Future<CareInvitation> createInvitation() async {
    final now = DateTime.now();
    final sent = _sent;
    if (sent != null && sent.expiresAt.isAfter(now)) return sent;
    return _sent = CareInvitation(
      code: '482913',
      status: 'pending',
      createdAt: now,
      expiresAt: now.add(const Duration(minutes: 15)),
    );
  }

  @override
  Future<InvitationPreview> preview(String code) async {
    if (code != mockInvitationCode) {
      throw const InvitationCodeException(InvitationCodeError.invalid);
    }
    final now = DateTime.now();
    return InvitationPreview(
      sender: const InvitationSender(firstName: 'Marek', role: 'caretaker'),
      status: 'pending',
      createdAt: now,
      expiresAt: now.add(const Duration(minutes: 15)),
    );
  }

  @override
  Future<void> accept(String code) async {
    if (code != mockInvitationCode) {
      throw const InvitationCodeException(InvitationCodeError.invalid);
    }
    _caretakers.add(
      CareRelationship(
        relationshipId: 'relationship-3',
        caretaker: const ContactCreator(
          userId: 'caretaker-3',
          firstName: 'Marek',
          lastName: 'Wiśniewski',
          role: 'caretaker',
        ),
        status: 'active',
        createdAt: DateTime.now().toUtc(),
      ),
    );
  }

  @override
  Future<List<CareRelationship>> caretakers(String seniorId) async =>
      List.of(_caretakers);

  @override
  Future<void> removeCaretaker(String relationshipId) async {
    _caretakers.removeWhere(
      (relationship) => relationship.relationshipId == relationshipId,
    );
  }
}
