import 'package:dio/dio.dart';
import 'package:mobile_zpi/features/auth/shared/controllers/auth_controller.dart';
import 'package:mobile_zpi/features/profile/data/models/account.dart';
import 'package:mobile_zpi/features/profile/data/models/contact_channel.dart';
import 'package:mobile_zpi/features/profile/data/repository/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  Future<Account> build() async {
    // The accessibility controller keeps the profile alive, so load it again
    // when another account signs in.
    await ref.watch(
      authControllerProvider.selectAsync((session) => session?.user.userId),
    );
    return ref.watch(profileRepositoryProvider).getAccount();
  }

  Future<void> updateName({
    required String firstName,
    required String lastName,
  }) async {
    final current = await future;
    final updated = await ref
        .read(profileRepositoryProvider)
        .updateAccount(
          version: current.version,
          firstName: firstName,
          lastName: lastName,
        );
    state = AsyncData(updated);
  }

  Future<void> confirmContactChange({
    required ContactChannel channel,
    required String challengeId,
    required String code,
  }) async {
    final repository = ref.read(profileRepositoryProvider);
    Future<Account> confirm(int version) => repository.confirmContactChange(
      channel: channel,
      version: version,
      challengeId: challengeId,
      code: code,
    );

    final current = await future;
    Account updated;
    try {
      updated = await confirm(current.version);
    } on DioException catch (e) {
      if (e.response?.statusCode != 412) rethrow;
      updated = await confirm((await repository.getAccount()).version);
    }
    if (ref.mounted) state = AsyncData(updated);
  }
}
