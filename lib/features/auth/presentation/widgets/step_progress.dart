import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

class StepProgress extends StatelessWidget {
  const StepProgress({
    super.key,
    required this.currentStep,
    required this.stepCount,
    this.duration = const Duration(milliseconds: 300),
  });

  final int currentStep;
  final int stepCount;
  final Duration duration;

  static const double _barHeight = 8;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Krok ${currentStep + 1} z $stepCount',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.sm,
        children: [
          Row(
            spacing: AppSpacing.sm,
            children: [
              for (var i = 0; i < stepCount; i++)
                Expanded(
                  child: AnimatedContainer(
                    duration: duration,
                    height: _barHeight,
                    decoration: BoxDecoration(
                      color: i <= currentStep
                          ? AppColors.primary
                          : AppColors.disabled,
                      borderRadius: AppRadius.fullAll,
                    ),
                  ),
                ),
            ],
          ),
          Text(
            'Krok ${currentStep + 1} z $stepCount',
            textAlign: TextAlign.center,
            style: AppTypography.labelLarge,
          ),
        ],
      ),
    );
  }
}
