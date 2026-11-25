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

  static const _caretaker = ContactCreator(
    userId: 'caretaker-1',
    firstName: 'Katarzyna',
    lastName: 'Wiśniewska',
    role: 'caretaker',
  );

  static final _records = [
    MedicalRecord(
      recordId: mockMedicalRecordId,
      seniorId: '',
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
      createdBy: _caretaker,
      createdAt: DateTime.utc(2026, 10, 15, 9),
      updatedAt: DateTime.utc(2026, 10, 15, 9),
      version: 1,
    ),
    MedicalRecord(
      recordId: 'record-2',
      seniorId: '',
      title: 'Recepta na leki na nadciśnienie',
      description:
          'Ramipril 5 mg, jedna tabletka rano. Recepta ważna 30 dni, '
          'kod do realizacji w aptece jest w SMS-ie.',
      recordType: 'prescription',
      documentDate: '2026-11-03',
      files: const [],
      createdBy: _caretaker,
      createdAt: DateTime.utc(2026, 11, 3, 14),
      updatedAt: DateTime.utc(2026, 11, 3, 14),
      version: 1,
    ),
    MedicalRecord(
      recordId: 'record-3',
      seniorId: '',
      title: 'Konsultacja kardiologiczna',
      description:
          'Ciśnienie w normie przy obecnym leczeniu. Kontrola za 6 miesięcy, '
          'wcześniej w razie duszności lub bólu w klatce piersiowej.',
      recordType: 'consultation',
      documentDate: '2026-10-28',
      files: const [],
      createdBy: _caretaker,
      createdAt: DateTime.utc(2026, 10, 28, 17),
      updatedAt: DateTime.utc(2026, 10, 28, 17),
      version: 1,
    ),
    MedicalRecord(
      recordId: 'record-4',
      seniorId: '',
      title: 'Wypis ze szpitala po zapaleniu płuc',
      description:
          'Pobyt na oddziale wewnętrznym od 2 do 9 września. Zalecony '
          'odpoczynek i kontrola u lekarza rodzinnego po tygodniu.',
      recordType: 'dischargeSummary',
      documentDate: '2026-09-09',
      files: const [],
      createdBy: _caretaker,
      createdAt: DateTime.utc(2026, 9, 10, 10),
      updatedAt: DateTime.utc(2026, 9, 10, 10),
      version: 1,
    ),
  ];

  @override
  Future<List<MedicalRecord>> records(String seniorId) async => [
    for (final record in _records) record.copyWith(seniorId: seniorId),
  ];

  @override
  Future<MedicalRecord> record(String seniorId, String recordId) async {
    final match = _records.where((record) => record.recordId == recordId);
    if (match.isEmpty) {
      throw StateError('Unknown medical record: $recordId');
    }
    return match.first.copyWith(seniorId: seniorId);
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
