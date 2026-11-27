import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/invitations/controllers/invitations_controller.dart';
import 'package:mobile_zpi/features/invitations/data/invitation_exceptions.dart';
import 'package:mobile_zpi/features/invitations/presentation/widgets/invitation_preview_body.dart';
import 'package:mobile_zpi/keys.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';
import 'package:mobile_zpi/widgets/app_code_input.dart';
import 'package:mobile_zpi/widgets/app_icon_circle.dart';
import 'package:mobile_zpi/widgets/back_scaffold.dart';

@RoutePage()
class AcceptInvitationView extends HookConsumerWidget {
  const AcceptInvitationView({super.key, required this.seniorId, this.code});

  final String seniorId;
  final String? code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codeController = useVerificationCodeController();
    final notifier = ref.read(invitationCodeControllerProvider.notifier);
    final state = ref.watch(invitationCodeControllerProvider);

    ref.listen(invitationCodeControllerProvider, (_, next) {
      if (next.hasError) codeController.clear();
    });

    void submit(String value) {
      codeController.text = value;
      notifier.check(value);
    }

    useEffect(() {
      final initialCode = code;
      if (initialCode == null) return null;
      WidgetsBinding.instance.addPostFrameCallback((_) => submit(initialCode));
      return null;
    }, const []);

    Future<void> onAccept() async {
      if (!await notifier.accept(codeController.text)) return;
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Opiekun został dodany.')));
      final router = context.router;
      if (router.stackData.any((r) => r.name == CaretakersRoute.name)) {
        router.popUntilRouteWithName(CaretakersRoute.name);
      } else {
        router.popUntilRouteWithName(AddCaretakerRoute.name);
        unawaited(router.replace(CaretakersRoute(seniorId: seniorId)));
      }
    }

    Future<void> onScan() async {
      final scanned = await context.router.push<String>(
        const ScanInvitationRoute(),
      );
      if (scanned == null || !context.mounted) return;
      submit(scanned);
    }

    return BackScaffold(
      title: 'Kod od opiekuna',
      body: switch (state) {
        AsyncData(value: final preview?) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: InvitationPreviewBody(
              preview: preview,
              onAccept: onAccept,
              onCancel: () => context.router.pop(),
            ),
          ),
        ),
        _ => Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(child: AppIconCircle(icon: Icons.dialpad_rounded)),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Wpisz kod od opiekuna',
                  textAlign: TextAlign.center,
                  style: AppTypography.headlineSmall.copyWith(
                    color: context.colors.onBackground,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Ten kod dostaniesz od opiekuna. '
                  'Znajdzie go w swojej aplikacji.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyLarge.copyWith(
                    color: context.colors.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                AppCodeInput(
                  key: keys.acceptInvitation.codeInput,
                  controller: codeController,
                  autoFocus: code == null,
                  errorText: switch (state) {
                    AsyncError(:final error) => _errorText(error),
                    _ => null,
                  },
                  onChanged: (value) {
                    if (value.isNotEmpty && state.hasError) notifier.clear();
                  },
                  onCompleted: notifier.check,
                ),
                const SizedBox(height: AppSpacing.xxl),
                if (state.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  AppButton.secondary(
                    label: 'Zeskanuj kod QR',
                    icon: Icons.qr_code_scanner,
                    onPressed: onScan,
                  ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      },
    );
  }

  String _errorText(Object error) {
    return switch (error) {
      InvitationCodeException(error: InvitationCodeError.invalid) =>
        'Kod jest nieprawidłowy albo wygasł.',
      InvitationCodeException(error: InvitationCodeError.notForYou) =>
        'Ten kod nie jest dla Ciebie. Poproś opiekuna o jego kod.',
      InvitationCodeException(error: InvitationCodeError.used) =>
        'Ten kod został już wykorzystany.',
      InvitationCodeException(error: InvitationCodeError.alreadyLinked) =>
        'Ten opiekun jest już połączony z Twoim kontem.',
      InvitationCodeException(error: InvitationCodeError.tooManyAttempts) =>
        'Zbyt wiele prób. Spróbuj ponownie później.',
      _ => 'Nie udało się sprawdzić kodu. Spróbuj ponownie.',
    };
  }
}
