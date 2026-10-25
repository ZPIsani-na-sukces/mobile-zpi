import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/med_history/controllers/med_record_controller.dart';
import 'package:mobile_zpi/features/med_history/data/models/medical_record.dart';
import 'package:mobile_zpi/features/med_history/presentation/med_history_labels.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';
import 'package:pdfx/pdfx.dart';

class MedFileCard extends StatelessWidget {
  const MedFileCard({
    super.key,
    required this.seniorId,
    required this.recordId,
    required this.file,
  });

  final String seniorId;
  final String recordId;
  final MedicalFile file;

  static const double _previewHeight = 240;

  @override
  Widget build(BuildContext context) {
    void open() => context.router.push(
      MedFilePreviewRoute(seniorId: seniorId, recordId: recordId, file: file),
    );

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        boxShadow: AppShadows.sm,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ExcludeSemantics(
              child: GestureDetector(
                onTap: open,
                child: ClipRRect(
                  borderRadius: AppRadius.mdAll,
                  child: ColoredBox(
                    color: AppColors.background,
                    child: SizedBox(
                      height: _previewHeight,
                      child: _Thumbnail(
                        seniorId: seniorId,
                        recordId: recordId,
                        file: file,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              file.originalName,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.onBackground,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              formatFileInfo(file),
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton.primary(
              label: 'Otwórz podgląd',
              icon: Icons.open_in_full,
              onPressed: open,
            ),
          ],
        ),
      ),
    );
  }
}

class _Thumbnail extends ConsumerWidget {
  const _Thumbnail({
    required this.seniorId,
    required this.recordId,
    required this.file,
  });

  final String seniorId;
  final String recordId;
  final MedicalFile file;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = ref.watch(
      medFileContentControllerProvider(seniorId, recordId, file.fileId),
    );

    return switch (content) {
      AsyncData(:final value) when file.isPdf => _PdfFirstPage(bytes: value),
      AsyncData(:final value) => Image.memory(
        value,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => const _PreviewError(),
      ),
      AsyncError() => const _PreviewError(),
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _PdfFirstPage extends HookWidget {
  const _PdfFirstPage({required this.bytes});

  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    final page = useFuture(useMemoized(() => _renderFirstPage(bytes), [bytes]));

    return switch (page) {
      AsyncSnapshot(:final data?) => Image.memory(data, fit: BoxFit.contain),
      AsyncSnapshot(hasError: true) => const _PreviewError(),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

Future<Uint8List> _renderFirstPage(Uint8List bytes) async {
  final document = await PdfDocument.openData(bytes);
  try {
    final page = await document.getPage(1);
    try {
      final image = await page.render(width: page.width, height: page.height);
      return image!.bytes;
    } finally {
      await page.close();
    }
  } finally {
    await document.close();
  }
}

class _PreviewError extends StatelessWidget {
  const _PreviewError();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Text(
          'Nie udało się wczytać podglądu.',
          textAlign: TextAlign.center,
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.onBackground,
          ),
        ),
      ),
    );
  }
}
