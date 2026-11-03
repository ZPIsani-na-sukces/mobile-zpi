import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/med_history/controllers/med_record_controller.dart';
import 'package:mobile_zpi/features/med_history/data/models/medical_record.dart';
import 'package:mobile_zpi/features/med_history/presentation/med_history_labels.dart';
import 'package:mobile_zpi/features/profile/controllers/profile_controller.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_message.dart';

@RoutePage()
class MedHistoryView extends ConsumerWidget {
  const MedHistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);

    return switch (profile) {
      AsyncData(value: final account) => _RecordList(seniorId: account.userId),
      AsyncError() => AppMessage(
        text: 'Nie udało się wczytać profilu.',
        actionLabel: 'Spróbuj ponownie',
        onPressed: () => ref.invalidate(profileControllerProvider),
      ),
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _RecordList extends ConsumerWidget {
  const _RecordList({required this.seniorId});

  final String seniorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = medRecordsControllerProvider(seniorId);
    final records = ref.watch(provider);

    return switch (records) {
      AsyncData(value: final items) when items.isEmpty => const AppMessage(
        text: 'Brak dokumentów medycznych.',
      ),
      AsyncData(value: final items) => RefreshIndicator(
        onRefresh: () => ref.refresh(provider.future),
        child: ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) => _RecordCard(record: items[index]),
        ),
      ),
      AsyncError() => AppMessage(
        text: 'Nie udało się wczytać dokumentów.',
        actionLabel: 'Spróbuj ponownie',
        onPressed: () => ref.invalidate(provider),
      ),
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _RecordCard extends StatelessWidget {
  const _RecordCard({required this.record});

  final MedicalRecord record;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: context.colors.cardBorder,
        borderRadius: AppRadius.lgAll,
        boxShadow: AppShadows.sm,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: AppRadius.lgAll,
          onTap: () => context.router.push(
            MedFileRoute(seniorId: record.seniorId, recordId: record.recordId),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  medicalRecordTypeLabel(record.recordType),
                  style: AppTypography.labelLarge.copyWith(
                    color: context.colors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  record.title,
                  style: AppTypography.titleLarge.copyWith(
                    color: context.colors.onBackground,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  formatDocumentDate(record.documentDate),
                  style: AppTypography.bodyMedium.copyWith(
                    color: context.colors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
