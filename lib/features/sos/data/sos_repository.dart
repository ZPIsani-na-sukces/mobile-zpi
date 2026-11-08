import 'package:dio/dio.dart';
import 'package:mobile_zpi/config/app_env.dart';
import 'package:mobile_zpi/features/devices/data/repository/device_repository.dart';
import 'package:mobile_zpi/features/sos/data/sos_alarm.dart';
import 'package:mobile_zpi/features/sos/data/sos_location.dart';
import 'package:mobile_zpi/network/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sos_repository.g.dart';

abstract interface class SosRepository {
  Future<SosAlarm> trigger({
    required String seniorId,
    required DateTime triggeredAt,
    SosFix? position,
  });
}

@Riverpod(keepAlive: true)
SosRepository sosRepository(Ref ref) {
  if (AppEnv.useMocks) return MockSosRepository();
  return ApiSosRepository(
    ref.watch(authDioProvider),
    ref.watch(deviceRepositoryProvider),
  );
}

class ApiSosRepository implements SosRepository {
  ApiSosRepository(this._dio, this._devices);

  final Dio _dio;
  final DeviceRepository _devices;

  @override
  Future<SosAlarm> trigger({
    required String seniorId,
    required DateTime triggeredAt,
    SosFix? position,
  }) async {
    final deviceId = await _devices.deviceId(seniorId);
    try {
      return await _send(seniorId, deviceId, triggeredAt, position);
    } on DioException catch (error) {
      if (error.response?.statusCode != 404) rethrow;
      final registered = await _devices.registerMonitoring(seniorId);
      return _send(seniorId, registered, triggeredAt, position);
    }
  }

  /// The API answers 201 for a new incident and 200 when the press joined
  /// the incident that is still open.
  Future<SosAlarm> _send(
    String seniorId,
    String deviceId,
    DateTime triggeredAt,
    SosFix? position,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
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
                // The API rejects a fix newer than the trigger. A fresh fix or
                // a GPS clock ahead of the phone would otherwise lose the SOS.
                'capturedAt':
                    (position.capturedAt.isAfter(triggeredAt)
                            ? triggeredAt
                            : position.capturedAt)
                        .toUtc()
                        .toIso8601String(),
              },
      },
    );
    return SosAlarm(
      isNew: response.statusCode == 201,
      occurredAt: DateTime.parse(response.data!['occurredAt'] as String),
    );
  }
}

class MockSosRepository implements SosRepository {
  @override
  Future<SosAlarm> trigger({
    required String seniorId,
    required DateTime triggeredAt,
    SosFix? position,
  }) async => SosAlarm(isNew: true, occurredAt: triggeredAt);
}
