import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';

class LocationUnavailable extends StatelessWidget {
  const LocationUnavailable({
    super.key,
    required this.onRetry,
    required this.onOpenSettings,
  });

  final VoidCallback onRetry;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.lg,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.sm,
              children: [
                Text(
                  'Nie udało się odczytać lokalizacji',
                  textAlign: TextAlign.center,
                  style: AppTypography.titleLarge.copyWith(
                    color: context.colors.onBackground,
                  ),
                ),
                Text(
                  'Włącz lokalizację i spróbuj ponownie.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyLarge.copyWith(
                    color: context.colors.onBackground,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.sm,
              children: [
                AppButton.primary(
                  label: 'Otwórz ustawienia lokalizacji',
                  onPressed: onOpenSettings,
                ),
                AppButton.secondary(
                  label: 'Spróbuj ponownie',
                  onPressed: onRetry,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
