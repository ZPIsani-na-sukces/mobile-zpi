import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mobile_zpi/features/auth/shared/data/auth_exceptions.dart';
import 'package:mobile_zpi/features/auth/shared/data/auth_repository.dart';
import 'package:mobile_zpi/features/auth/shared/data/models/auth_session.dart';
import 'package:mobile_zpi/features/auth/shared/data/session_storage.dart';
import 'package:mobile_zpi/features/location_tracking/data/plugin_tokens.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  Future<AuthSession?>? _renewal;

  @override
  Future<AuthSession?> build() => ref.read(sessionStorageProvider).read();

  Future<void> setSession(AuthSession session) async {
    await ref.read(sessionStorageProvider).write(session);
    state = AsyncData(session);
  }

  /// Returns a session newer than [rejectedToken], or null when it has ended.
  ///
  /// The backend revokes a session when a refresh token is used twice, so
  /// parallel 401s share one call. The session is read from storage because
  /// the SOS widget renews it from its own isolate.
  Future<AuthSession?> renewSession(String rejectedToken) =>
      _renewal ??= _renewSession(rejectedToken)
          .whenComplete(() => _renewal = null);

  Future<AuthSession?> _renewSession(String rejectedToken) async {
    final stored = await ref.read(sessionStorageProvider).read();
    if (stored == null) return null;

    if (stored.accessToken != rejectedToken) {
      state = AsyncData(stored);
      return stored;
    }

    final session = await sessionWithNewerPluginTokens(stored) ?? stored;
    try {
      final renewed = await ref
          .read(authRepositoryProvider)
          .refresh(session.refreshToken);
      await setSession(renewed);
      await sendTokensToPlugin(renewed);
      return renewed;
    } on SessionExpiredException {
      await logout();
      return null;
    }
  }

  Future<void> logout() async {
    final session = state.value;

    await ref.read(sessionStorageProvider).clear();
    state = const AsyncData(null);

    if (session == null) return;
    unawaited(
      ref
          .read(authRepositoryProvider)
          .logout(session)
          .catchError((Object e) => debugPrint('Server logout failed: $e')),
    );
  }
}
