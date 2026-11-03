import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';

class AppMessage extends StatelessWidget {
  const AppMessage({
    super.key,
    required this.text,
    this.actionLabel,
    this.onPressed,
  });

  final String text;
  final String? actionLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: AppTypography.bodyLarge.copyWith(
              color: context.colors.onBackground,
            ),
          ),
          if (actionLabel != null && onPressed != null) ...[
            const SizedBox(height: AppSpacing.lg),
            AppButton.primary(label: actionLabel!, onPressed: onPressed),
          ],
        ],
      ),
    );
  }
}
