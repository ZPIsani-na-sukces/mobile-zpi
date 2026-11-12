import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/med_history/controllers/med_record_controller.dart';
import 'package:mobile_zpi/features/med_history/presentation/med_history_labels.dart';
import 'package:mobile_zpi/features/med_history/presentation/widgets/med_file_card.dart';
import 'package:mobile_zpi/features/med_history/presentation/widgets/med_record_detail_row.dart';
import 'package:mobile_zpi/features/med_history/presentation/widgets/med_record_details_card.dart';
import 'package:mobile_zpi/features/med_history/presentation/widgets/med_record_type_badge.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_no_connection_info.dart';
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
            MedRecordTypeBadge(recordType: value.recordType),
            const SizedBox(height: AppSpacing.md),
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
            MedRecordDetailsCard(
              rows: [
                MedRecordDetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Data dokumentu',
                  value: formatDocumentDate(value.documentDate),
                ),
                if (value.createdBy case final creator?)
                  MedRecordDetailRow(
                    icon: Icons.person_outline,
                    label: 'Dodane przez',
                    value: '${creator.firstName} ${creator.lastName}',
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Pliki',
              style: AppTypography.titleLarge.copyWith(
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
        AsyncError() => AppNoConnectionInfo(
          onRetry: () =>
              ref.invalidate(medRecordControllerProvider(seniorId, recordId)),
        ),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
