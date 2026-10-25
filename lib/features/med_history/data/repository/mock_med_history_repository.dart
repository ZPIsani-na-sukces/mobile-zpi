import 'package:flutter/services.dart';
import 'package:mobile_zpi/features/contacts/data/models/contact.dart';
import 'package:mobile_zpi/features/med_history/data/models/medical_record.dart';
import 'package:mobile_zpi/features/med_history/data/repository/med_history_repository.dart';

const mockMedicalRecordId = 'record-1';

class MockMedHistoryRepository implements MedHistoryRepository {
  static const _assets = {
    'file-1': 'assets/mocks/med_history/morfologia.pdf',
    'file-2': 'assets/mocks/med_history/skierowanie.jpg',
  };

  @override
  Future<MedicalRecord> record(String seniorId, String recordId) async {
    if (recordId != mockMedicalRecordId) {
      throw StateError('Unknown medical record: $recordId');
    }
    return MedicalRecord(
      recordId: recordId,
      seniorId: seniorId,
      title: 'Morfologia i biochemia krwi',
      description:
          'Wyniki badań kontrolnych z przychodni. Zabierz je na wizytę '
          'u kardiologa razem ze skierowaniem.',
      recordType: 'testResult',
      documentDate: '2026-10-14',
      files: [
        MedicalFile(
          fileId: 'file-1',
          originalName: 'morfologia.pdf',
          mimeType: 'application/pdf',
          sizeBytes: 22065,
          createdAt: DateTime.utc(2026, 10, 15, 9),
        ),
        MedicalFile(
          fileId: 'file-2',
          originalName: 'skierowanie.jpg',
          mimeType: 'image/jpeg',
          sizeBytes: 81119,
          createdAt: DateTime.utc(2026, 10, 15, 9),
        ),
      ],
      createdBy: const ContactCreator(
        userId: 'caregiver-1',
        firstName: 'Katarzyna',
        lastName: 'Wiśniewska',
        role: 'CAREGIVER',
      ),
      createdAt: DateTime.utc(2026, 10, 15, 9),
      updatedAt: DateTime.utc(2026, 10, 15, 9),
      version: 1,
    );
  }

  @override
  Future<Uint8List> fileContent(
    String seniorId,
    String recordId,
    String fileId,
  ) async {
    final data = await rootBundle.load(_assets[fileId]!);
    return data.buffer.asUint8List();
  }
}
