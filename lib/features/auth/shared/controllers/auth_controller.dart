import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mobile_zpi/features/auth/shared/data/auth_repository.dart';
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
    final session = state.value;

    await ref.read(sessionStorageProvider).clear();
    state = const AsyncData(null);

    if (session == null) return;
    unawaited(
      ref
          .read(authRepositoryProvider)
          .logout(session.accessToken)
          .catchError((Object e) => debugPrint('Server logout failed: $e')),
    );
  }
}
