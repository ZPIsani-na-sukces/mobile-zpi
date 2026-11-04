import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';

class EmptyZonesCard extends StatelessWidget {
  const EmptyZonesCard({super.key, required this.onOpenMap});

  final VoidCallback onOpenMap;

  static const double _iconSize = 32;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: context.colors.cardBorder,
        borderRadius: AppRadius.lgAll,
        boxShadow: AppShadows.sm,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.place_outlined,
                  color: context.colors.primary,
                  size: _iconSize,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Brak ustawionych geostref',
                        style: AppTypography.titleMedium.copyWith(
                          color: context.colors.onBackground,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Poproś opiekuna o ich dodanie.',
                        style: AppTypography.bodyLarge.copyWith(
                          color: context.colors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton.secondary(
              label: 'Otwórz mapę',
              icon: Icons.map_outlined,
              onPressed: onOpenMap,
            ),
          ],
        ),
      ),
    );
  }
}
