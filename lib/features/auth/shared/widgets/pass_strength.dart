import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile_zpi/features/auth/shared/validation/pass_strength_level.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:password_strength_checker/password_strength_checker.dart';

class PassStrength extends HookWidget {
  const PassStrength({super.key, required this.controller});

  final TextEditingController controller;

  static const _configuration = PasswordStrengthCheckerConfiguration(
    height: 16,
    borderWidth: 2,
    inactiveBorderColor: AppColors.disabled,
    externalBorderRadius: AppRadius.fullAll,
    internalBorderRadius: AppRadius.fullAll,
    statusMargin: EdgeInsets.only(top: AppSpacing.sm),
    animationDuration: _animationDuration,
  );

  static const _animationDuration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final strength = useValueNotifier(
      PassStrengthLevel.calculate(controller.text),
    );

    useEffect(() {
      void update() =>
          strength.value = PassStrengthLevel.calculate(controller.text);
      controller.addListener(update);
      return () => controller.removeListener(update);
    }, [controller]);

    final isEmpty = useValueListenable(strength) == null;

    return AnimatedSize(
      duration: _animationDuration,
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: isEmpty
          ? const SizedBox(width: double.infinity)
          : Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: PasswordStrengthChecker<PassStrengthLevel>(
                strength: strength,
                configuration: _configuration,
              ),
            ),
    );
  }
}
