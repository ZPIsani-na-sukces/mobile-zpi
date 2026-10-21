import 'package:mobile_zpi/features/med_history/data/models/medical_record.dart';

String medicalRecordTypeLabel(String type) {
  return switch (type) {
    'testResult' => 'Wynik badania',
    'prescription' => 'Recepta',
    'dischargeSummary' => 'Wypis ze szpitala',
    'consultation' => 'Konsultacja',
    'other' => 'Inny dokument',
    _ => type,
  };
}

String formatDocumentDate(String date) {
  final value = DateTime.tryParse(date);
  if (value == null) return date;
  final day = value.day.toString().padLeft(2, '0');
  final month = value.month.toString().padLeft(2, '0');
  return '$day.$month.${value.year}';
}

String formatFileInfo(MedicalFile file) {
  final kind = file.isPdf ? 'PDF' : 'Zdjęcie';
  return '$kind · ${_formatSize(file.sizeBytes)}';
}

String _formatSize(int bytes) {
  const kb = 1024;
  const mb = kb * 1024;
  if (bytes < kb) return '$bytes B';
  if (bytes < mb) return '${(bytes / kb).round()} KB';
  return '${(bytes / mb).toStringAsFixed(1).replaceAll('.', ',')} MB';
}
