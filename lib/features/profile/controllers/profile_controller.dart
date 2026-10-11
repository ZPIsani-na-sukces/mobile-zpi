import 'package:mobile_zpi/features/profile/data/models/account.dart';
import 'package:mobile_zpi/features/profile/data/repository/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  Future<Account> build() => ref.watch(profileRepositoryProvider).getAccount();

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
}
