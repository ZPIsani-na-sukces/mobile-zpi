import 'package:mobile_zpi/features/devices/data/repository/device_repository.dart';

class MockDeviceRepository implements DeviceRepository {
  static const _deviceId = 'mock-device';

  @override
  Future<String> registerMonitoring(String userId) async => _deviceId;

  @override
  Future<String> deviceId(String userId) async => _deviceId;
}
