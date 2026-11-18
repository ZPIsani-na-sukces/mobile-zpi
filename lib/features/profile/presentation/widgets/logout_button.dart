import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/auth/shared/controllers/auth_controller.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> onPressed() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: context.colors.surface,
          surfaceTintColor: Colors.transparent,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
          title: Text(
            'Wylogować się?',
            style: AppTypography.headlineSmall.copyWith(
              color: context.colors.onBackground,
            ),
          ),
          content: Text(
            'Aby wrócić do aplikacji, trzeba będzie zalogować się ponownie.',
            style: AppTypography.bodyLarge.copyWith(
              color: context.colors.onSurface,
            ),
          ),
          actions: [
            AppButton.text(
              label: 'Anuluj',
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            AppButton.primary(
              label: 'Wyloguj',
              onPressed: () => Navigator.of(dialogContext).pop(true),
            ),
          ],
        ),
      );
      if (confirmed != true) return;

      await ref.read(authControllerProvider.notifier).logout();
      if (!context.mounted) return;
      await context.router.replaceAll([const LoginRoute()]);
    }

    return AppButton.text(
      label: 'Wyloguj się',
      icon: Icons.logout,
      onPressed: onPressed,
    );
  }
}
