import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile_zpi/features/invitations/presentation/widgets/add_caretaker_option.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/widgets/app_button.dart';
import 'package:mobile_zpi/widgets/back_scaffold.dart';

@RoutePage()
class AddCaretakerView extends StatelessWidget {
  const AddCaretakerView({super.key, required this.seniorId});

  final String seniorId;

  @override
  Widget build(BuildContext context) {
    return BackScaffold(
      title: 'Dodaj opiekuna',
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          AddCaretakerOption(
            title: 'Masz kod od opiekuna?',
            description: 'Opiekun widzi kod QR i 6 cyfr w swojej aplikacji.',
            actions: [
              AppButton.primary(
                label: 'Zeskanuj kod QR',
                icon: Icons.qr_code_scanner,
                onPressed: () => _scan(context),
              ),
              AppButton.text(
                label: 'Wpisz kod ręcznie',
                icon: Icons.dialpad,
                onPressed: () => context.router.push(
                  AcceptInvitationRoute(seniorId: seniorId),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AddCaretakerOption(
            title: 'Opiekun nie ma kodu?',
            description: 'Pokaż mu swój kod. Wpisze go w swojej aplikacji.',
            actions: [
              AppButton.primary(
                label: 'Pokaż mój kod',
                icon: Icons.pin,
                onPressed: () =>
                    context.router.push(const SendInvitationRoute()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _scan(BuildContext context) async {
    final code = await context.router.push<String>(const ScanInvitationRoute());
    if (code == null || !context.mounted) return;
    await context.router.push(
      AcceptInvitationRoute(seniorId: seniorId, code: code),
    );
  }
}
