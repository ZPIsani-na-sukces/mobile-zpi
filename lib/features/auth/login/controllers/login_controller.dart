import 'package:mobile_zpi/features/auth/shared/controllers/auth_controller.dart';
import 'package:mobile_zpi/features/auth/shared/data/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_controller.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<void> build() {}

  Future<void> login(String identifier, String password) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final session = await ref
          .read(authRepositoryProvider)
          .login(identifier, password);
      await ref.read(authControllerProvider.notifier).setSession(session);
    });
    if (ref.mounted) state = result;
  }
}
