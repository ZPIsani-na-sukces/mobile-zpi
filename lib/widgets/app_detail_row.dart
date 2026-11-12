import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_icon_circle.dart';

class AppDetailRow extends StatelessWidget {
  const AppDetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  static const _evenLeading = TextHeightBehavior(
    leadingDistribution: TextLeadingDistribution.even,
  );

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Row(
        children: [
          ExcludeSemantics(child: AppIconCircle.small(icon: icon)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    textHeightBehavior: _evenLeading,
                    style: AppTypography.bodyMedium.copyWith(
                      color: context.colors.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    value,
                    textHeightBehavior: _evenLeading,
                    style: AppTypography.titleMedium.copyWith(
                      color: context.colors.onBackground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
