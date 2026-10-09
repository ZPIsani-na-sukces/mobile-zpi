import 'package:mobile_zpi/features/auth/pass_reset/models/set_new_pass_request.dart';
import 'package:mobile_zpi/features/auth/shared/data/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'set_new_pass_controller.g.dart';

@riverpod
class SetNewPassController extends _$SetNewPassController {
  @override
  FutureOr<void> build() {}

  Future<void> submit(SetNewPassRequest request) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).setNewPassword(request),
    );
    if (ref.mounted) state = result;
  }

  void clearError() {
    if (state.hasError && !state.isLoading) state = const AsyncData(null);
  }
}
