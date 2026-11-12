import 'package:flutter/material.dart';
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

IconData medicalRecordTypeIcon(String type) {
  return switch (type) {
    'testResult' => Icons.science_outlined,
    'prescription' => Icons.medication_outlined,
    'dischargeSummary' => Icons.local_hospital_outlined,
    'consultation' => Icons.medical_services_outlined,
    _ => Icons.description_outlined,
  };
}

String fileTypeLabel(MedicalFile file) =>
    file.isPdf ? 'Dokument PDF' : 'Zdjęcie';

String fileTypeIconAsset(MedicalFile file) {
  return switch (file.mimeType) {
    'application/pdf' => 'assets/icons/pdf.svg',
    'image/png' => 'assets/icons/png.svg',
    _ => 'assets/icons/jpg.svg',
  };
}

String fileDisplayName(MedicalFile file) {
  final name = file.originalName;
  final dot = name.lastIndexOf('.');
  return dot > 0 ? name.substring(0, dot) : name;
}
