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

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasError = errorText != null && enabled;
    final borderWidth = colors.isHighContrast ? 2.0 : 1.5;
    final activeBorderWidth = colors.isHighContrast ? 3.0 : 2.0;
    final bottomText = errorText ?? helperText;

    final borderColor = switch ((enabled, hasError)) {
      (false, _) => colors.inputBorderDisabled,
      (_, true) => colors.error,
      _ => colors.inputBorder,
    };
    final border = OutlineInputBorder(
      borderRadius: AppRadius.mdAll,
      borderSide: BorderSide(
        color: borderColor,
        width: hasError ? activeBorderWidth : borderWidth,
      ),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: AppRadius.mdAll,
      borderSide: BorderSide(
        color: hasError ? colors.error : colors.primary,
        width: activeBorderWidth,
      ),
    );
    final fillColor = switch ((enabled, hasError)) {
      (false, _) => colors.background,
      (_, true) => colors.inputErrorBackground,
      _ => colors.surface,
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
              color: hasError ? colors.error : colors.onSurface,
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
                cursorColor: colors.primary,
                filled: true,
                fillColor: fillColor,
                focusedFillColor: hasError ? colors.inputErrorBackground : null,
                border: border,
                focusedBorder: focusedBorder,
                textStyle: AppTypography.headlineSmall.copyWith(
                  color: enabled
                      ? colors.onSurface
                      : colors.inputContentDisabled,
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
              color: hasError ? colors.error : colors.inputHelper,
            ),
          ),
      ],
    );
  }
}
