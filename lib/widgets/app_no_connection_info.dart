import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';
import 'package:mobile_zpi/widgets/app_icon_circle.dart';

class AppNoConnectionInfo extends StatelessWidget {
  const AppNoConnectionInfo({
    super.key,
    required this.onRetry,
    this.secondaryAction,
  });

  final VoidCallback onRetry;
  final Widget? secondaryAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AppIconCircle(icon: Icons.wifi_off_rounded),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Brak połączenia',
            textAlign: TextAlign.center,
            style: AppTypography.headlineSmall.copyWith(
              color: context.colors.onBackground,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Sprawdź połączenie z Wi-Fi lub siecią komórkową, aby przejść dalej.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyLarge.copyWith(
              color: context.colors.onBackground,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          AppButton.primary(label: 'Spróbuj ponownie', onPressed: onRetry),
          if (secondaryAction case final action?) ...[
            const SizedBox(height: AppSpacing.md),
            action,
          ],
        ],
      ),
    );
  }
}
