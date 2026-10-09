import 'package:mobile_zpi/features/auth/shared/data/models/auth_session.dart';
import 'package:mobile_zpi/features/auth/shared/data/session_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Future<AuthSession?> build() => ref.read(sessionStorageProvider).read();

  Future<void> setSession(AuthSession session) async {
    await ref.read(sessionStorageProvider).write(session);
    state = AsyncData(session);
  }

  Future<void> logout() async {
    await ref.read(sessionStorageProvider).clear();
    state = const AsyncData(null);
  }
}
