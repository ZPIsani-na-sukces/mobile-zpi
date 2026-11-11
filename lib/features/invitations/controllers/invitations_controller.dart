import 'package:mobile_zpi/features/invitations/data/models/care_invitation.dart';
import 'package:mobile_zpi/features/invitations/data/repository/invitations_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'invitations_controller.g.dart';

@riverpod
class CaretakersController extends _$CaretakersController {
  @override
  Future<List<CareRelationship>> build(String seniorId) =>
      ref.watch(invitationsRepositoryProvider).caretakers(seniorId);

  Future<void> remove(String relationshipId) async {
    await ref
        .read(invitationsRepositoryProvider)
        .removeCaretaker(relationshipId);
    ref.invalidateSelf();
  }
}

@riverpod
class SentInvitationController extends _$SentInvitationController {
  @override
  Future<CareInvitation> build() =>
      ref.watch(invitationsRepositoryProvider).createInvitation();
}

@riverpod
class InvitationCodeController extends _$InvitationCodeController {
  @override
  FutureOr<InvitationPreview?> build() => null;

  Future<void> check(String code) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(invitationsRepositoryProvider).preview(code),
    );
    if (ref.mounted) state = result;
  }

  Future<bool> accept(String code) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard<InvitationPreview?>(() async {
      await ref.read(invitationsRepositoryProvider).accept(code);
      ref.invalidate(caretakersControllerProvider);
      return null;
    });
    if (ref.mounted) state = result;
    return !result.hasError;
  }

  void clear() => state = const AsyncData(null);
}
