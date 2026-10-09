import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:verification_code_field/verification_code_field.dart';

export 'package:verification_code_field/verification_code_field.dart'
    show CodeDigit, VerificationCodeController;

VerificationCodeController useVerificationCodeController() {
  final controller = useMemoized(VerificationCodeController.new);
  useEffect(() => controller.dispose, [controller]);
  return controller;
}

class AppCodeInput extends StatelessWidget {
  const AppCodeInput({
    super.key,
    required this.controller,
    this.codeDigit = CodeDigit.six,
    this.label,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.autoFocus = false,
    this.onChanged,
    this.onCompleted,
  });

  final VerificationCodeController controller;
  final CodeDigit codeDigit;
  final String? label;
  final String? helperText;
  final String? errorText;
  final bool enabled;
  final bool autoFocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;

  static const double _maxFieldSize = 56;
  static const double _boxSpacing = 10;

  static const Color _borderDefault = Color(0xFFCBD5E1);
  static const Color _borderDisabled = Color(0xFFE2E8F0);
  static const Color _disabledContent = Color(0xFF94A3B8);
  static const Color _helper = Color(0xFF596573);
  static const Color _errorBackground = Color(0xFFFFF5F5);

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && enabled;
    final bottomText = errorText ?? helperText;

    final borderColor = switch ((enabled, hasError)) {
      (false, _) => _borderDisabled,
      (_, true) => AppColors.error,
      _ => _borderDefault,
    };
    final border = OutlineInputBorder(
      borderRadius: AppRadius.mdAll,
      borderSide: BorderSide(color: borderColor, width: hasError ? 2 : 1.5),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: AppRadius.mdAll,
      borderSide: BorderSide(
        color: hasError ? AppColors.error : AppColors.primary,
        width: 2,
      ),
    );
    final fillColor = switch ((enabled, hasError)) {
      (false, _) => AppColors.background,
      (_, true) => _errorBackground,
      _ => AppColors.surface,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.xs,
      children: [
        if (label != null)
          Text(
            label!,
            style: AppTypography.labelMedium.copyWith(
              color: hasError ? AppColors.error : AppColors.onSurface,
            ),
          ),
        LayoutBuilder(
          builder: (context, constraints) {
            final digits = codeDigit.digit;
            final fieldSize = min(
              _maxFieldSize,
              (constraints.maxWidth - _boxSpacing * (digits - 1)) / digits,
            );

            return Center(
              child: VerificationCodeField(
                controller: controller,
                codeDigit: codeDigit,
                fieldSize: fieldSize,
                enabled: enabled,
                autoFocus: autoFocus,
                clearOnTap: false,
                showCursor: true,
                cursorColor: AppColors.primary,
                filled: true,
                fillColor: fillColor,
                focusedFillColor: hasError ? _errorBackground : null,
                border: border,
                focusedBorder: focusedBorder,
                textStyle: AppTypography.headlineSmall.copyWith(
                  color: enabled ? AppColors.onSurface : _disabledContent,
                ),
                onChanged: onChanged,
                onSubmit: onCompleted,
              ),
            );
          },
        ),
        if (bottomText != null)
          Text(
            bottomText,
            style: AppTypography.caption.copyWith(
              color: hasError ? AppColors.error : _helper,
            ),
          ),
      ],
    );
  }
}
