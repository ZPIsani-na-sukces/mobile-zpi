import 'package:mobile_zpi/features/auth/acc_activation/models/activate_acc_request.dart';
import 'package:mobile_zpi/features/auth/shared/controllers/auth_controller.dart';
import 'package:mobile_zpi/features/auth/shared/data/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'activate_acc_controller.g.dart';

class AutoLoginFailedException implements Exception {
  const AutoLoginFailedException();
}

@riverpod
class ActivateAccController extends _$ActivateAccController {
  @override
  FutureOr<void> build() {}

  Future<void> activate({
    required ActivateAccRequest request,
    required String identifier,
    required String password,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);
    final result = await AsyncValue.guard(() async {
      await repository.activateAccount(request);
      try {
        final session = await repository.login(identifier, password);
        await ref.read(authControllerProvider.notifier).setSession(session);
      } catch (_) {
        throw const AutoLoginFailedException();
      }
    });
    if (ref.mounted) state = result;
  }

  void clearError() {
    if (state.hasError && !state.isLoading) state = const AsyncData(null);
  }
}
