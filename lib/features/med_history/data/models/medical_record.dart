import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_zpi/features/contacts/data/models/contact.dart';

part 'medical_record.freezed.dart';
part 'medical_record.g.dart';

@freezed
abstract class MedicalRecord with _$MedicalRecord {
  const factory MedicalRecord({
    required String recordId,
    required String seniorId,
    required String title,
    String? description,
    required String recordType,
    required String documentDate,
    required List<MedicalFile> files,
    required ContactCreator createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) = _MedicalRecord;

  factory MedicalRecord.fromJson(Map<String, dynamic> json) =>
      _$MedicalRecordFromJson(json);
}

@freezed
abstract class MedicalFile with _$MedicalFile {
  const MedicalFile._();

  const factory MedicalFile({
    required String fileId,
    required String originalName,
    required String mimeType,
    required int sizeBytes,
    required DateTime createdAt,
  }) = _MedicalFile;

  factory MedicalFile.fromJson(Map<String, dynamic> json) =>
      _$MedicalFileFromJson(json);

  bool get isPdf => mimeType == 'application/pdf';
}
