import 'package:flutter/material.dart';
import 'package:mobile_zpi/features/invitations/presentation/widgets/section_card.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

class AddCaretakerOption extends StatelessWidget {
  const AddCaretakerOption({
    super.key,
    required this.title,
    required this.description,
    required this.actions,
  });

  final String title;
  final String description;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.sm,
        children: [
          Text(
            title,
            style: AppTypography.titleLarge.copyWith(
              color: context.colors.onBackground,
            ),
          ),
          Text(
            description,
            style: AppTypography.bodyLarge.copyWith(
              color: context.colors.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          ...actions,
        ],
      ),
    );
  }
}
