import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/med_history/controllers/med_record_controller.dart';
import 'package:mobile_zpi/features/med_history/presentation/med_history_labels.dart';
import 'package:mobile_zpi/features/med_history/presentation/widgets/med_file_card.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/back_scaffold.dart';

@RoutePage()
class MedFileView extends ConsumerWidget {
  const MedFileView({
    super.key,
    required this.seniorId,
    required this.recordId,
  });

  final String seniorId;
  final String recordId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final record = ref.watch(medRecordControllerProvider(seniorId, recordId));

    return BackScaffold(
      title: 'Dokument',
      body: switch (record) {
        AsyncData(:final value) => ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              medicalRecordTypeLabel(value.recordType),
              style: AppTypography.labelLarge.copyWith(
                color: context.colors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value.title,
              style: AppTypography.headlineSmall.copyWith(
                color: context.colors.onBackground,
              ),
            ),
            if (value.description case final description?
                when description.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                description,
                style: AppTypography.bodyLarge.copyWith(
                  color: context.colors.onBackground,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            _Row(
              label: 'Data dokumentu',
              value: formatDocumentDate(value.documentDate),
            ),
            _Row(
              label: 'Dodane przez',
              value: '${value.createdBy.firstName} ${value.createdBy.lastName}',
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Pliki',
              style: AppTypography.titleMedium.copyWith(
                color: context.colors.onBackground,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (value.files.isEmpty)
              Text(
                'Brak plików.',
                style: AppTypography.bodyLarge.copyWith(
                  color: context.colors.onBackground,
                ),
              ),
            for (final file in value.files)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: MedFileCard(
                  seniorId: seniorId,
                  recordId: recordId,
                  file: file,
                ),
              ),
          ],
        ),
        AsyncError() => const Center(
          child: Text('Nie udało się wczytać dokumentu.'),
        ),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.labelLarge.copyWith(
              color: context.colors.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.bodyLarge.copyWith(
              color: context.colors.onBackground,
            ),
          ),
        ],
      ),
    );
  }
}
