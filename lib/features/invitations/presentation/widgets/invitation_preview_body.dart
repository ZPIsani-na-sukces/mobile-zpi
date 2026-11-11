import 'package:flutter/material.dart';
import 'package:mobile_zpi/features/invitations/data/models/care_invitation.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';
import 'package:mobile_zpi/widgets/app_icon_circle.dart';

class InvitationPreviewBody extends StatelessWidget {
  const InvitationPreviewBody({
    super.key,
    required this.preview,
    required this.onAccept,
    required this.onCancel,
  });

  final InvitationPreview preview;
  final VoidCallback onAccept;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const AppIconCircle(icon: Icons.person_add_alt_1_rounded),
                  const SizedBox(height: AppSpacing.xl),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: preview.sender.firstName,
                          style: const TextStyle(
                            fontWeight: AppTypography.bold,
                          ),
                        ),
                        const TextSpan(text: ' chce zostać Twoim opiekunem'),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: AppTypography.headlineSmall.copyWith(
                      color: context.colors.onBackground,
                      fontWeight: AppTypography.regular,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton.primary(label: 'Przyjmij', onPressed: onAccept),
        const SizedBox(height: AppSpacing.sm),
        AppButton.text(label: 'Anuluj', onPressed: onCancel),
      ],
    );
  }
}
