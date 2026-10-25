import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/profile/controllers/accessibility_controller.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

class HighContrastSwitch extends ConsumerWidget {
  const HighContrastSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final preferences = ref.watch(accessibilityControllerProvider);
    final enabled = ref.watch(highContrastControllerProvider).value ?? false;

    Future<void> onChanged(bool value) async {
      try {
        await ref
            .read(accessibilityControllerProvider.notifier)
            .setHighContrast(value);
      } catch (_) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nie udało się zapisać. Spróbuj ponownie.'),
          ),
        );
      }
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: colors.cardBorder,
        borderRadius: AppRadius.lgAll,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: SwitchListTile(
          value: enabled,
          onChanged: preferences.value == null ? null : onChanged,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          title: Text(
            'Wysoki kontrast',
            style: AppTypography.titleMedium.copyWith(color: colors.onSurface),
          ),
          subtitle: Text(
            preferences.hasError && !preferences.hasValue
                ? 'Nie udało się wczytać ustawienia.'
                : 'Wyraźniejsze kolory i obramowania. Opiekun też może '
                      'to zmienić.',
            style: AppTypography.bodyMedium.copyWith(color: colors.onSurface),
          ),
        ),
      ),
    );
  }
}
