import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/sos/controllers/sos_controller.dart';
import 'package:mobile_zpi/features/sos/data/sos_location.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';
import 'package:mobile_zpi/widgets/back_scaffold.dart';

@RoutePage()
class SosView extends HookConsumerWidget {
  const SosView({super.key, required this.seniorId});

  final String seniorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(sosControllerProvider);
    final started = useRef(false);

    useEffect(() {
      if (started.value) return null;
      started.value = true;
      unawaited(ref.read(sosControllerProvider.notifier).start(seniorId));
      return null;
    }, const []);

    final canCancel =
        flow.phase == SosPhase.locating || flow.phase == SosPhase.gpsError;

    return BackScaffold(
      title: 'SOS',
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _SosBody(flow: flow, seniorId: seniorId),
            ),
            if (canCancel)
              AppButton.secondary(
                label: 'Anuluj',
                onPressed: () => context.router.pop(),
              ),
          ],
        ),
      ),
    );
  }
}

class _SosBody extends ConsumerWidget {
  const _SosBody({required this.flow, required this.seniorId});

  final SosFlow flow;
  final String seniorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (flow.phase) {
      SosPhase.locating => const _Message(
        title: 'Pobieranie lokalizacji',
        body: 'Za chwilę wyślemy wezwanie do opiekuna.',
        busy: true,
      ),
      SosPhase.sending => const _Message(
        title: 'Wysyłanie wezwania',
        body: 'Proszę czekać.',
        busy: true,
      ),
      SosPhase.gpsError => _Message(
        title: 'Brak lokalizacji',
        body: flow.message ?? 'Nie udało się odczytać pozycji.',
        actionLabel: 'Wyślij bez lokalizacji',
        onPressed: () {
          unawaited(
            ref
                .read(sosControllerProvider.notifier)
                .sendWithoutLocation(seniorId),
          );
        },
      ),
      SosPhase.waiting => _Message(
        title: 'Czekamy na pomoc',
        body: 'Wezwanie zostało wysłane do opiekuna.',
        detail: _locationLabel(flow.position),
      ),
      SosPhase.failed => _Message(
        title: 'Wezwanie nie wyszło',
        body: flow.message ?? 'Spróbuj ponownie.',
        actionLabel: 'Spróbuj ponownie',
        onPressed: () {
          unawaited(ref.read(sosControllerProvider.notifier).start(seniorId));
        },
      ),
    };
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.title,
    required this.body,
    this.detail,
    this.busy = false,
    this.actionLabel,
    this.onPressed,
  });

  final String title;
  final String body;
  final String? detail;
  final bool busy;
  final String? actionLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (busy) ...[
          const CircularProgressIndicator(),
          const SizedBox(height: AppSpacing.lg),
        ],
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          body,
          textAlign: TextAlign.center,
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.onBackground,
          ),
        ),
        if (detail != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            detail!,
            textAlign: TextAlign.center,
            style: AppTypography.bodyLarge.copyWith(color: AppColors.onSurface),
          ),
        ],
        if (actionLabel != null && onPressed != null) ...[
          const SizedBox(height: AppSpacing.xl),
          AppButton.primary(label: actionLabel!, onPressed: onPressed),
        ],
      ],
    );
  }
}

String _locationLabel(SosFix? position) {
  if (position == null) return 'Wysłano bez lokalizacji.';
  final lat = position.latitude.toStringAsFixed(5);
  final lng = position.longitude.toStringAsFixed(5);
  final accuracy = position.accuracyMeters?.round();
  final accuracyText = accuracy == null ? '' : ' Dokładność około $accuracy m.';
  return 'Bieżąca lokalizacja: $lat, $lng.$accuracyText';
}
