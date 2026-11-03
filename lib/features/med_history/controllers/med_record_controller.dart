import 'dart:typed_data';

import 'package:mobile_zpi/features/med_history/data/models/medical_record.dart';
import 'package:mobile_zpi/features/med_history/data/repository/med_history_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'med_record_controller.g.dart';

@riverpod
class MedRecordsController extends _$MedRecordsController {
  @override
  Future<List<MedicalRecord>> build(String seniorId) =>
      ref.watch(medHistoryRepositoryProvider).records(seniorId);
}

@riverpod
class MedRecordController extends _$MedRecordController {
  @override
  Future<MedicalRecord> build(String seniorId, String recordId) =>
      ref.watch(medHistoryRepositoryProvider).record(seniorId, recordId);
}

@riverpod
class MedFileContentController extends _$MedFileContentController {
  @override
  Future<Uint8List> build(String seniorId, String recordId, String fileId) =>
      ref
          .watch(medHistoryRepositoryProvider)
          .fileContent(seniorId, recordId, fileId);
}
