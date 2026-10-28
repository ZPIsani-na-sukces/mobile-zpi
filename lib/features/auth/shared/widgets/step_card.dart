import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

class StepCard extends StatelessWidget {
  const StepCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: context.colors.surface,
            border: context.colors.cardBorder,
            borderRadius: AppRadius.xxlAll,
            boxShadow: AppShadows.sm,
          ),
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.md,
              children: [
                Column(
                  spacing: AppSpacing.xs,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AppTypography.headlineSmall,
                    ),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyLarge,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
