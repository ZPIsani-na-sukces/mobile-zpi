import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accessibility_storage.g.dart';

/// Keeps the last known high contrast flag on the device, so the app starts
/// in the right theme before the API answers and also when it is offline.
class AccessibilityStorage {
  AccessibilityStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _highContrastKey = 'high_contrast_enabled';

  Future<bool> readHighContrast() async {
    try {
      return await _storage.read(key: _highContrastKey) == 'true';
    } catch (_) {
      return false;
    }
  }

  Future<void> writeHighContrast(bool enabled) =>
      _storage.write(key: _highContrastKey, value: '$enabled');
}

@Riverpod(keepAlive: true)
AccessibilityStorage accessibilityStorage(Ref ref) =>
    AccessibilityStorage(const FlutterSecureStorage());
