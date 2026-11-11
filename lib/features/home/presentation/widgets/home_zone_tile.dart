import 'package:flutter/material.dart';
import 'package:mobile_zpi/features/home/data/models/home_overview.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

class HomeZoneTile extends StatelessWidget {
  const HomeZoneTile({super.key, required this.zone, required this.onTap});

  final HomeZone zone;
  final VoidCallback onTap;

  static const double _iconSize = 28;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Semantics(
      button: true,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          borderRadius: AppRadius.lgAll,
          boxShadow: AppShadows.sm,
        ),
        child: Material(
          color: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.lgAll,
            side: colors.isHighContrast
                ? BorderSide(color: colors.outline, width: 2)
                : BorderSide.none,
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            highlightColor: colors.surfacePressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.place_outlined,
                    size: _iconSize,
                    color: colors.primary,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      zone.name,
                      style: AppTypography.titleMedium.copyWith(
                        color: colors.onBackground,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '${zone.radiusMeters.round()} m',
                    style: AppTypography.bodyLarge.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Icon(
                    Icons.chevron_right,
                    size: _iconSize,
                    color: colors.onSurface,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
