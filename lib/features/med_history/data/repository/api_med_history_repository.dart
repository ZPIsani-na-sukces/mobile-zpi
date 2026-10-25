import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:mobile_zpi/features/med_history/data/models/medical_record.dart';
import 'package:mobile_zpi/features/med_history/data/repository/med_history_repository.dart';

class ApiMedHistoryRepository implements MedHistoryRepository {
  ApiMedHistoryRepository(this._dio);

  final Dio _dio;

  @override
  Future<MedicalRecord> record(String seniorId, String recordId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/seniors/$seniorId/medical-records/$recordId',
    );
    return MedicalRecord.fromJson(response.data!);
  }

  @override
  Future<Uint8List> fileContent(
    String seniorId,
    String recordId,
    String fileId,
  ) async {
    final response = await _dio.get<Uint8List>(
      '/seniors/$seniorId/medical-records/$recordId/files/$fileId/content',
      options: Options(responseType: ResponseType.bytes),
    );
    return response.data!;
  }
}
