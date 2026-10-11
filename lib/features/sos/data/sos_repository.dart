import 'package:dio/dio.dart';
import 'package:mobile_zpi/config/app_env.dart';
import 'package:mobile_zpi/features/sos/data/sos_location.dart';
import 'package:mobile_zpi/network/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sos_repository.g.dart';

class SosDeviceMissingException implements Exception {
  const SosDeviceMissingException();
}

abstract interface class SosRepository {
  Future<void> trigger({
    required String seniorId,
    required DateTime triggeredAt,
    SosFix? position,
  });
}

@Riverpod(keepAlive: true)
SosRepository sosRepository(Ref ref) {
  if (AppEnv.useMocks) return MockSosRepository();
  return ApiSosRepository(ref.watch(authDioProvider));
}

class ApiSosRepository implements SosRepository {
  ApiSosRepository(this._dio);

  final Dio _dio;

  @override
  Future<void> trigger({
    required String seniorId,
    required DateTime triggeredAt,
    SosFix? position,
  }) async {
    final deviceId = await _deviceId();
    await _dio.post<Map<String, dynamic>>(
      '/seniors/$seniorId/sos-incidents',
      data: {
        'deviceId': deviceId,
        'triggeredAt': triggeredAt.toUtc().toIso8601String(),
        'position': position == null
            ? null
            : {
                'coordinates': {
                  'latitude': position.latitude,
                  'longitude': position.longitude,
                },
                'accuracyMeters': position.accuracyMeters,
                'speedMps': position.speedMps,
                'capturedAt': position.capturedAt.toUtc().toIso8601String(),
              },
      },
    );
  }

  Future<String> _deviceId() async {
    final response = await _dio.get<List<dynamic>>('/me/devices');
    final devices = response.data!;
    Map<String, dynamic>? chosen;
    for (final item in devices) {
      final device = item as Map<String, dynamic>;
      if (device['monitoringEnabled'] == true) {
        chosen = device;
        break;
      }
      chosen ??= device;
    }
    final deviceId = chosen?['deviceId'];
    if (deviceId is! String || deviceId.isEmpty) {
      throw const SosDeviceMissingException();
    }
    return deviceId;
  }
}

class MockSosRepository implements SosRepository {
  @override
  Future<void> trigger({
    required String seniorId,
    required DateTime triggeredAt,
    SosFix? position,
  }) async {}
}
