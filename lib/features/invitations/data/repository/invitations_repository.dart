import 'package:mobile_zpi/config/app_env.dart';
import 'package:mobile_zpi/features/invitations/data/models/care_invitation.dart';
import 'package:mobile_zpi/features/invitations/data/repository/api_invitations_repository.dart';
import 'package:mobile_zpi/features/invitations/data/repository/mock_invitations_repository.dart';
import 'package:mobile_zpi/network/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'invitations_repository.g.dart';

abstract interface class InvitationsRepository {
  /// Returns the pending invitation when one exists, so it is safe to repeat.
  Future<CareInvitation> createInvitation();
  Future<InvitationPreview> preview(String code);
  Future<void> accept(String code);
  Future<List<CareRelationship>> caretakers(String seniorId);
  Future<void> removeCaretaker(String relationshipId);
}

@Riverpod(keepAlive: true)
InvitationsRepository invitationsRepository(Ref ref) {
  if (AppEnv.useMocks) return MockInvitationsRepository();
  return ApiInvitationsRepository(ref.watch(authDioProvider));
}
