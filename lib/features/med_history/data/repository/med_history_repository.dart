import 'dart:typed_data';

import 'package:mobile_zpi/config/app_env.dart';
import 'package:mobile_zpi/features/med_history/data/models/medical_record.dart';
import 'package:mobile_zpi/features/med_history/data/repository/api_med_history_repository.dart';
import 'package:mobile_zpi/features/med_history/data/repository/mock_med_history_repository.dart';
import 'package:mobile_zpi/network/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'med_history_repository.g.dart';

abstract interface class MedHistoryRepository {
  Future<List<MedicalRecord>> records(String seniorId);

  Future<MedicalRecord> record(String seniorId, String recordId);

  Future<Uint8List> fileContent(
    String seniorId,
    String recordId,
    String fileId,
  );
}

@Riverpod(keepAlive: true)
MedHistoryRepository medHistoryRepository(Ref ref) {
  if (AppEnv.useMocks) return MockMedHistoryRepository();
  return ApiMedHistoryRepository(ref.watch(authDioProvider));
}
