import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';

class DevSection extends StatelessWidget {
  const DevSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        Text(
          'Dev',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.onBackground,
          ),
        ),
        AppButton.secondary(
          label: 'Playground',
          icon: Icons.bug_report_outlined,
          onPressed: () => context.router.push(const PlaygroudRoute()),
        ),
        AppButton.secondary(
          label: 'Logowanie',
          onPressed: () => context.router.push(const LoginRoute()),
        ),
        AppButton.secondary(
          label: 'Rejestracja',
          onPressed: () => context.router.push(const RegisterRoute()),
        ),
        AppButton.secondary(
          label: 'Reset hasła',
          onPressed: () => context.router.push(const ResetPassRoute()),
        ),
      ],
    );
  }
}
