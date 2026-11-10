import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

class SosDetailRow extends StatelessWidget {
  const SosDetailRow({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.titleEmphasis,
    this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? titleEmphasis;
  final String? subtitle;

  static const double _iconSize = 32;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.md,
        children: [
          Icon(icon, size: _iconSize, color: iconColor),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xs,
              children: [
                if (titleEmphasis case final emphasis?)
                  Text.rich(
                    TextSpan(
                      text: '$title ',
                      children: [
                        TextSpan(
                          text: emphasis,
                          style: const TextStyle(
                            fontWeight: AppTypography.bold,
                          ),
                        ),
                      ],
                    ),
                    style: AppTypography.bodyLarge.copyWith(
                      color: context.colors.onSurface,
                    ),
                  )
                else
                  Text(
                    title,
                    style: AppTypography.titleMedium.copyWith(
                      color: context.colors.onSurface,
                    ),
                  ),
                if (subtitle case final subtitle?)
                  Text(
                    subtitle,
                    style: AppTypography.bodyLarge.copyWith(
                      color: context.colors.onSurface,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
