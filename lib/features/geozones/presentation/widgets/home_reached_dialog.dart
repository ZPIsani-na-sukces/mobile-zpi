import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';

class HomeReachedDialog extends StatelessWidget {
  const HomeReachedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.colors.surface,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
      icon: Icon(Icons.home_outlined, color: context.colors.primary),
      title: Text(
        'Jesteś w domu',
        style: AppTypography.headlineSmall.copyWith(
          color: context.colors.onBackground,
        ),
      ),
      content: Text(
        'Nawigacja do domu została zakończona.',
        style: AppTypography.bodyLarge.copyWith(
          color: context.colors.onSurface,
        ),
      ),
      actions: [
        AppButton.text(
          label: 'Zamknij',
          onPressed: () => Navigator.of(context).pop(false),
        ),
        AppButton.primary(
          label: 'Ekran główny',
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
