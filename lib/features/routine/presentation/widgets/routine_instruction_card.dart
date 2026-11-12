import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_card.dart';

class RoutineInstructionCard extends StatelessWidget {
  const RoutineInstructionCard({super.key, required this.instructions});

  final String instructions;

  static const double _iconSize = 28;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(
            child: Icon(
              Icons.info_outline,
              size: _iconSize,
              color: colors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              instructions,
              style: AppTypography.bodyLarge.copyWith(
                color: colors.onBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
