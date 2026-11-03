import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/invitations/controllers/invitations_controller.dart';
import 'package:mobile_zpi/features/invitations/data/models/care_invitation.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';
import 'package:mobile_zpi/widgets/app_message.dart';
import 'package:mobile_zpi/widgets/back_scaffold.dart';

@RoutePage()
class SendInvitationView extends ConsumerWidget {
  const SendInvitationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invitation = ref.watch(sentInvitationControllerProvider);
    void reload() => ref.invalidate(sentInvitationControllerProvider);

    return BackScaffold(
      title: 'Zaproś opiekuna',
      body: switch (invitation) {
        AsyncData(:final value) => _Code(invitation: value, onExpired: reload),
        AsyncError() => AppMessage(
          text: 'Nie udało się utworzyć kodu.',
          actionLabel: 'Spróbuj ponownie',
          onPressed: reload,
        ),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Code extends HookWidget {
  const _Code({required this.invitation, required this.onExpired});

  final CareInvitation invitation;
  final VoidCallback onExpired;

  Duration get _remaining => invitation.expiresAt.difference(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final remaining = useState(_remaining);

    useEffect(() {
      remaining.value = _remaining;
      final timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => remaining.value = _remaining,
      );
      return timer.cancel;
    }, [invitation]);

    final expired = remaining.value <= Duration.zero;
    final code = invitation.code;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(
          'Podaj ten kod opiekunowi. Wpisze go w swojej aplikacji.',
          textAlign: TextAlign.center,
          style: AppTypography.bodyLarge.copyWith(
            color: context.colors.onBackground,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Semantics(
          label: 'Kod zaproszenia ${code.split('').join(' ')}',
          excludeSemantics: true,
          child: Text(
            '${code.substring(0, 3)} ${code.substring(3)}',
            textAlign: TextAlign.center,
            style: AppTypography.displayLarge.copyWith(
              color: expired
                  ? context.colors.onSurface
                  : context.colors.primary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          expired
              ? 'Kod wygasł.'
              : 'Kod ważny jeszcze ${_format(remaining.value)}',
          textAlign: TextAlign.center,
          style: AppTypography.titleMedium.copyWith(
            color: context.colors.onBackground,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        if (expired)
          AppButton.primary(label: 'Utwórz nowy kod', onPressed: onExpired)
        else
          AppButton.secondary(
            label: 'Skopiuj kod',
            icon: Icons.copy,
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: code));
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kod został skopiowany.')),
              );
            },
          ),
      ],
    );
  }

  String _format(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
