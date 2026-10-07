import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_zpi/features/auth/data/models/auth_session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_storage.g.dart';

class SessionStorage {
  SessionStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _key = 'auth_session';

  Future<AuthSession?> read() async {
    try {
      final raw = await _storage.read(key: _key);
      if (raw == null) return null;
      return AuthSession.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      await clear();
      return null;
    }
  }

  Future<void> write(AuthSession session) =>
      _storage.write(key: _key, value: jsonEncode(session.toJson()));

  Future<void> clear() => _storage.delete(key: _key);
}

@Riverpod(keepAlive: true)
SessionStorage sessionStorage(Ref ref) =>
    SessionStorage(const FlutterSecureStorage());
