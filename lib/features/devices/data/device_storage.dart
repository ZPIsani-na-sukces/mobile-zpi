import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'device_storage.g.dart';

class DeviceStorage {
  DeviceStorage(this._storage);

  final FlutterSecureStorage _storage;

  String _installationKey(String userId) => 'device_installation_$userId';

  String _deviceKey(String userId) => 'device_id_$userId';

  Future<String> installationId(String userId) async {
    final key = _installationKey(userId);
    final stored = await _storage.read(key: key);
    if (stored != null) return stored;

    final created = const Uuid().v4();
    await _storage.write(key: key, value: created);
    return created;
  }

  Future<String?> deviceId(String userId) =>
      _storage.read(key: _deviceKey(userId));

  Future<void> writeDeviceId(String userId, String deviceId) =>
      _storage.write(key: _deviceKey(userId), value: deviceId);
}

@Riverpod(keepAlive: true)
DeviceStorage deviceStorage(Ref ref) =>
    DeviceStorage(const FlutterSecureStorage());
