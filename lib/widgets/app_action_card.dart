import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_icon_circle.dart';

class AppActionCard extends StatelessWidget {
  const AppActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  }) : filled = false;

  const AppActionCard.filled({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  }) : filled = true;

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool filled;

  static const double _iconSize = 28;
  static const double _filledIconSize = 36;

  @override
  Widget build(BuildContext context) {
    final subtitle = this.subtitle;
    final colors = context.colors;
    final background = filled ? colors.primary : colors.surface;
    final titleColor = filled ? colors.onPrimary : colors.onBackground;
    final contentColor = filled ? colors.onPrimary : colors.onSurface;

    return Semantics(
      button: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: AppRadius.lgAll,
          boxShadow: filled ? AppShadows.md : AppShadows.sm,
        ),
        child: Material(
          color: background,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.lgAll,
            side: colors.isHighContrast && !filled
                ? BorderSide(color: colors.outline, width: 2)
                : BorderSide.none,
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            highlightColor: filled
                ? colors.primaryVariant
                : colors.surfacePressed,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  ExcludeSemantics(
                    child: filled
                        ? SizedBox.square(
                            dimension: AppIconCircle.smallSize,
                            child: Icon(
                              icon,
                              size: _filledIconSize,
                              color: colors.onPrimary,
                            ),
                          )
                        : AppIconCircle.small(icon: icon),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTypography.titleMedium.copyWith(
                            color: titleColor,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            subtitle,
                            style: AppTypography.bodyMedium.copyWith(
                              color: contentColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Icon(
                    Icons.chevron_right,
                    size: _iconSize,
                    color: contentColor,
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
