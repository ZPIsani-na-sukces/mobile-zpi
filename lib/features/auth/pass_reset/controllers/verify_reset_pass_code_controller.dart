import 'package:mobile_zpi/features/auth/pass_reset/models/verify_reset_pass_code_request.dart';
import 'package:mobile_zpi/features/auth/shared/data/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'verify_reset_pass_code_controller.g.dart';

@riverpod
class VerifyResetPassCodeController extends _$VerifyResetPassCodeController {
  @override
  FutureOr<void> build() {}

  Future<void> verify(VerifyResetPassCodeRequest request) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).verifyResetCode(request),
    );
    if (ref.mounted) state = result;
  }

  void clearError() {
    if (state.hasError && !state.isLoading) state = const AsyncData(null);
  }
}
