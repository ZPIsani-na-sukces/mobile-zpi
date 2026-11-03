import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mobile_zpi/features/devices/data/device_storage.dart';
import 'package:mobile_zpi/features/devices/data/repository/device_repository.dart';

class ApiDeviceRepository implements DeviceRepository {
  ApiDeviceRepository(this._dio, this._storage);

  final Dio _dio;
  final DeviceStorage _storage;

  @override
  Future<String> registerMonitoring(String userId) async {
    final installationId = await _storage.installationId(userId);
    String deviceId;
    try {
      deviceId = await _register(installationId, monitoringEnabled: true);
    } on DioException catch (error) {
      if (error.response?.data case {'code': 'activeDeviceExists'}) {
        deviceId = await _register(installationId, monitoringEnabled: false);
        await _dio.post<void>('/me/devices/$deviceId/switch');
      } else {
        rethrow;
      }
    }
    await _storage.writeDeviceId(userId, deviceId);
    return deviceId;
  }

  @override
  Future<String> deviceId(String userId) async =>
      await _storage.deviceId(userId) ?? await registerMonitoring(userId);

  Future<String> _register(
    String installationId, {
    required bool monitoringEnabled,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/me/devices',
      data: {
        'installationId': installationId,
        'platform': Platform.isIOS ? 'ios' : 'android',
        'appVersion': const String.fromEnvironment(
          'FLUTTER_BUILD_NAME',
          defaultValue: '1.0.0',
        ),
        'monitoringEnabled': monitoringEnabled,
      },
    );
    return response.data!['deviceId'] as String;
  }
}
