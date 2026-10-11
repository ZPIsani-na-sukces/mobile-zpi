import 'package:mobile_zpi/features/profile/data/models/home_address.dart';
import 'package:mobile_zpi/features/profile/data/repository/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_address_controller.g.dart';

@riverpod
class HomeAddressController extends _$HomeAddressController {
  @override
  Future<HomeAddress?> build(String seniorId) =>
      ref.watch(profileRepositoryProvider).getHomeAddress(seniorId);

  Future<void> save(HomeAddressInput input) async {
    final current = await future;
    final saved = await ref
        .read(profileRepositoryProvider)
        .saveHomeAddress(
          seniorId: seniorId,
          version: current?.version,
          input: input,
        );
    state = AsyncData(saved);
  }
}
