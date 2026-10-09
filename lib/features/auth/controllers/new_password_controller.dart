import 'package:mobile_zpi/features/auth/data/models/new_password_request.dart';
import 'package:mobile_zpi/features/auth/data/repository/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_password_controller.g.dart';

@riverpod
class NewPasswordController extends _$NewPasswordController {
  @override
  FutureOr<void> build() {}

  Future<void> submit(NewPasswordRequest request) async {
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
