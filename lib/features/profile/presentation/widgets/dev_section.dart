import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/med_history/data/repository/mock_med_history_repository.dart';
import 'package:mobile_zpi/features/profile/data/repository/profile_repository.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';

class DevSection extends ConsumerWidget {
  const DevSection({super.key, required this.seniorId});

  final String seniorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        Text(
          'Dev',
          style: AppTypography.titleLarge.copyWith(
            color: context.colors.onBackground,
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
        AppButton.secondary(
          label: 'Dokument medyczny',
          onPressed: () => context.router.push(
            MedFileRoute(seniorId: seniorId, recordId: mockMedicalRecordId),
          ),
        ),
        AppButton.secondary(
          label: 'Kontrast od opiekuna',
          onPressed: () => _toggleContrastAsCaregiver(ref),
        ),
      ],
    );
  }

  // Saves past the app's controller, like a caregiver in the web panel, so
  // the change shows up only after the next refresh.
  Future<void> _toggleContrastAsCaregiver(WidgetRef ref) async {
    final repository = ref.read(profileRepositoryProvider);
    final current = await repository.getAccessibilityPreferences(seniorId);
    await repository.saveAccessibilityPreferences(
      current.copyWith(highContrastEnabled: !current.highContrastEnabled),
    );
  }
}
