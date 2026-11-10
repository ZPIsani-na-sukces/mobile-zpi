import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/sos/controllers/sos_controller.dart';
import 'package:mobile_zpi/features/sos/data/sos_alarm.dart';
import 'package:mobile_zpi/features/sos/presentation/widgets/sos_details_card.dart';
import 'package:mobile_zpi/features/sos/presentation/widgets/sos_status.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
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
    final colors = context.colors;

    void start() =>
        unawaited(ref.read(sosControllerProvider.notifier).start(seniorId));
    void close() => context.router.pop();

    useEffect(() {
      if (started.value) return null;
      started.value = true;
      start();
      return null;
    }, const []);

    final status = switch (flow.phase) {
      SosPhase.locating => SosStatus(
        icon: Icons.my_location,
        color: colors.primary,
        onColor: colors.onPrimary,
        busy: true,
        title: 'Sprawdzamy, gdzie jesteś',
        body: 'Za chwilę wyślemy wezwanie do opiekuna.',
      ),
      SosPhase.sending => SosStatus(
        icon: Icons.send,
        color: colors.primary,
        onColor: colors.onPrimary,
        busy: true,
        title: 'Wysyłamy wezwanie',
        body: 'Proszę czekać. To potrwa tylko chwilę.',
      ),
      SosPhase.waiting => SosStatus(
        icon: Icons.check,
        color: colors.success,
        onColor: colors.onSuccess,
        title: switch (flow.alarm) {
          SosAlarm(isNew: false) => 'Wezwanie jest aktywne',
          _ => 'Wezwanie wysłane',
        },
        body: switch (flow.alarm) {
          SosAlarm(isNew: false) => 'Pomoc jest już w drodze!',
          _ => 'Opiekun został powiadomiony.',
        },
      ),
      SosPhase.failed => SosStatus(
        icon: Icons.priority_high,
        color: colors.error,
        onColor: colors.onError,
        title: 'Nie udało się wysłać wezwania',
        body:
            flow.message ??
            'Sprawdź połączenie z internetem i spróbuj ponownie.',
      ),
    };

    final actions = switch (flow.phase) {
      SosPhase.locating => [
        AppButton.secondary(label: 'Anuluj', onPressed: close),
      ],
      SosPhase.sending => const <Widget>[],
      SosPhase.waiting => [
        AppButton.primary(label: 'Zamknij', onPressed: close),
      ],
      SosPhase.failed => [
        AppButton.primary(
          label: 'Spróbuj ponownie',
          icon: Icons.refresh,
          onPressed: start,
        ),
        AppButton.secondary(label: 'Zamknij', onPressed: close),
      ],
    };

    return BackScaffold(
      title: 'SOS',
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: (constraints.maxHeight - AppSpacing.lg * 2)
                          .clamp(0, double.infinity),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        status,
                        if (flow.phase == SosPhase.waiting) ...[
                          const SizedBox(height: AppSpacing.lg),
                          SosDetailsCard(
                            alarm: flow.alarm,
                            position: flow.position,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (actions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: AppSpacing.md,
                  children: actions,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
