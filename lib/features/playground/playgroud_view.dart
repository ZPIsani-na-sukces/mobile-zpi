import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';
import 'package:mobile_zpi/widgets/back_scaffold.dart';

@RoutePage()
class PlaygroudView extends StatelessWidget {
  const PlaygroudView({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressed() {}

    return BackScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.md,
          children: [
            const Center(
              child: Text('Buttons', style: AppTypography.headlineSmall),
            ),
            const Text('Primary', style: AppTypography.titleMedium),
            AppButton.primary(label: 'Primary', onPressed: onPressed),
            AppButton.primary(
              label: 'With icon',
              icon: Icons.add,
              onPressed: onPressed,
            ),
            const AppButton.primary(label: 'Disabled', onPressed: null),

            const Text('Secondary', style: AppTypography.titleMedium),
            AppButton.secondary(label: 'Secondary', onPressed: onPressed),
            AppButton.secondary(
              label: 'With icon',
              icon: Icons.add,
              onPressed: onPressed,
            ),
            const AppButton.secondary(label: 'Disabled', onPressed: null),

            const Text('Text', style: AppTypography.titleMedium),
            AppButton.text(label: 'Text', onPressed: onPressed),
            AppButton.text(
              label: 'With icon',
              icon: Icons.add,
              onPressed: onPressed,
            ),
            const AppButton.text(label: 'Disabled', onPressed: null),

            const Text('Full width', style: AppTypography.titleMedium),
            SizedBox(
              width: double.infinity,
              child: AppButton.primary(
                label: 'Full width',
                onPressed: onPressed,
              ),
            ),

            const SizedBox(height: AppSpacing.md),
            const Center(
              child: Text('Text inputs', style: AppTypography.headlineSmall),
            ),
          ],
        ),
      ),
    );
  }
}
