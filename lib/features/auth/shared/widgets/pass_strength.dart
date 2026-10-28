import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile_zpi/features/auth/shared/validation/pass_strength_level.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

class PassStrength extends HookWidget {
  const PassStrength({super.key, required this.controller});

  final TextEditingController controller;

  static const double _barHeight = 16;
  static const double _borderWidth = 2;
  static const Duration _animationDuration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final level = useListenableSelector(
      controller,
      () => PassStrengthLevel.calculate(controller.text),
    );

    return AnimatedSize(
      duration: _animationDuration,
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: level == null
          ? const SizedBox(width: double.infinity)
          : Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: _Meter(level: level),
            ),
    );
  }
}

class _Meter extends StatelessWidget {
  const _Meter({required this.level});

  final PassStrengthLevel level;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = level.color(colors);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        AnimatedContainer(
          duration: PassStrength._animationDuration,
          height: PassStrength._barHeight,
          padding: const EdgeInsets.all(PassStrength._borderWidth),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: AppRadius.fullAll,
            border: Border.all(color: color, width: PassStrength._borderWidth),
          ),
          child: AnimatedFractionallySizedBox(
            duration: PassStrength._animationDuration,
            widthFactor: level.widthPerc,
            child: AnimatedContainer(
              duration: PassStrength._animationDuration,
              decoration: BoxDecoration(
                color: color,
                borderRadius: AppRadius.fullAll,
              ),
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.xs,
          children: [
            Icon(level.icon, color: color, size: 20),
            Text(
              'Siła hasła: ${level.label}',
              style: AppTypography.labelLarge.copyWith(color: colors.onSurface),
            ),
          ],
        ),
      ],
    );
  }
}
