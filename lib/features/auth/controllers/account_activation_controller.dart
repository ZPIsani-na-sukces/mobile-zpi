import 'package:mobile_zpi/features/auth/controllers/auth_controller.dart';
import 'package:mobile_zpi/features/auth/data/models/confirm_challenge_request.dart';
import 'package:mobile_zpi/features/auth/data/repository/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_activation_controller.g.dart';

class AutoLoginFailedException implements Exception {
  const AutoLoginFailedException();
}

@riverpod
class AccountActivationController extends _$AccountActivationController {
  @override
  FutureOr<void> build() {}

  Future<void> activate({
    required ConfirmChallengeRequest request,
    required String identifier,
    required String password,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);
    final result = await AsyncValue.guard(() async {
      await repository.confirmPhone(request);
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
