import 'package:mobile_zpi/config/app_env.dart';
import 'package:mobile_zpi/features/devices/data/device_storage.dart';
import 'package:mobile_zpi/features/devices/data/repository/api_device_repository.dart';
import 'package:mobile_zpi/features/devices/data/repository/mock_device_repository.dart';
import 'package:mobile_zpi/network/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_repository.g.dart';

abstract interface class DeviceRepository {
  Future<String> registerMonitoring(String userId);

  Future<String> deviceId(String userId);
}

@Riverpod(keepAlive: true)
DeviceRepository deviceRepository(Ref ref) {
  if (AppEnv.useMocks) return MockDeviceRepository();
  return ApiDeviceRepository(
    ref.watch(authDioProvider),
    ref.watch(deviceStorageProvider),
  );
}
