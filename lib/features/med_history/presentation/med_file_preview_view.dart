import 'dart:async';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/med_history/controllers/med_record_controller.dart';
import 'package:mobile_zpi/features/med_history/data/models/medical_record.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/widgets/app_message.dart';
import 'package:mobile_zpi/widgets/app_no_connection_info.dart';
import 'package:mobile_zpi/widgets/back_scaffold.dart';
import 'package:pdfx/pdfx.dart';

@RoutePage()
class MedFilePreviewView extends ConsumerWidget {
  const MedFilePreviewView({
    super.key,
    required this.seniorId,
    required this.recordId,
    required this.file,
  });

  final String seniorId;
  final String recordId;
  final MedicalFile file;

  static const double _maxImageScale = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = medFileContentControllerProvider(
      seniorId,
      recordId,
      file.fileId,
    );
    final content = ref.watch(provider);

    return BackScaffold(
      title: file.originalName,
      body: switch (content) {
        AsyncData(:final value) when file.isPdf => _PdfPages(bytes: value),
        AsyncData(:final value) => InteractiveViewer(
          maxScale: _maxImageScale,
          child: SizedBox.expand(
            child: Image.memory(
              value,
              fit: BoxFit.contain,
              semanticLabel: 'Podgląd pliku ${file.originalName}',
              errorBuilder: (_, _, _) =>
                  const AppMessage(text: 'Nie udało się otworzyć pliku.'),
            ),
          ),
        ),
        AsyncError() => AppNoConnectionInfo(
          onRetry: () => ref.invalidate(provider),
        ),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _PdfPages extends HookWidget {
  const _PdfPages({required this.bytes});

  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    final document = useMemoized(() => PdfDocument.openData(bytes), [bytes]);
    final controller = useMemoized(
      () => PdfControllerPinch(document: document),
      [document],
    );
    useEffect(
      () => () {
        controller.dispose();
        unawaited(
          document.then((value) => value.close(), onError: (Object _) {}),
        );
      },
      [controller],
    );

    return PdfViewPinch(
      controller: controller,
      backgroundDecoration: BoxDecoration(
        color: context.colors.surface,
        boxShadow: AppShadows.sm,
      ),
      builders: const PdfViewPinchBuilders<DefaultBuilderOptions>(
        options: DefaultBuilderOptions(),
        errorBuilder: _pdfError,
      ),
    );
  }

  static Widget _pdfError(BuildContext context, Exception error) =>
      const AppMessage(text: 'Nie udało się otworzyć pliku.');
}
