import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

class AppTextInput extends HookWidget {
  const AppTextInput({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.optionalText,
    this.isSuccess = false,
    this.leadingIcon,
    this.trailingIcon,
    this.onTrailingIconPressed,
    this.trailingIconTooltip,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.autofocus = false,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final String? optionalText;
  final bool isSuccess;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final VoidCallback? onTrailingIconPressed;
  final String? trailingIconTooltip;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final bool autofocus;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  static const double _height = 56;
  static const double _iconSize = 24;
  static const double _actionSize = 40;
  static const Duration _animationDuration = Duration(milliseconds: 200);
  static const Curve _animationCurve = Curves.easeInOut;

  static const Color _borderDefault = Color(0xFFCBD5E1);
  static const Color _borderFilled = Color(0xFF64748B);
  static const Color _borderDisabled = Color(0xFFE2E8F0);
  static const Color _disabledContent = Color(0xFF94A3B8);
  static const Color _placeholder = Color(0xFF718096);
  static const Color _helper = Color(0xFF596573);
  static const Color _icon = Color(0xFF596573);
  static const Color _errorBackground = Color(0xFFFFF5F5);
  static const Color _successBackground = Color(0xFFF6FFF8);
  static const Color _readOnlyBackground = Color(0xFFF8FAFC);
  static const Color _focusGlow = Color(0x330067B8);
  static const Color _errorGlow = Color(0x26C62828);

  @override
  Widget build(BuildContext context) {
    final fallbackController = useTextEditingController();
    final fallbackFocusNode = useFocusNode();
    final effectiveController = controller ?? fallbackController;
    final effectiveFocusNode = focusNode ?? fallbackFocusNode;

    final focused = useListenableSelector(
      effectiveFocusNode,
      () => effectiveFocusNode.hasFocus,
    );
    final length = useListenableSelector(
      effectiveController,
      () => effectiveController.text.length,
    );

    final colors = _resolveColors(
      _resolveState(focused: focused, filled: length > 0),
    );
    final contentColor = enabled ? AppColors.onSurface : _disabledContent;
    final iconColor = enabled ? _icon : _disabledContent;
    final hasTrailingAction =
        trailingIcon != null && onTrailingIconPressed != null;
    final topTrailingText = maxLength != null
        ? '$length/$maxLength'
        : optionalText;
    final bottomText = errorText ?? helperText;

    final inputBox = GestureDetector(
      onTap: enabled ? effectiveFocusNode.requestFocus : null,
      child: CustomPaint(
        foregroundPainter: colors.dashed
            ? _DashedBorderPainter(
                color: colors.border,
                strokeWidth: colors.borderWidth,
              )
            : null,
        child: AnimatedContainer(
          duration: _animationDuration,
          curve: _animationCurve,
          height: _height,
          padding: EdgeInsetsDirectional.only(
            start: AppSpacing.md,
            end: hasTrailingAction ? AppSpacing.sm : AppSpacing.md,
            top: AppSpacing.sm,
            bottom: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: AppRadius.mdAll,
            boxShadow: colors.shadow,
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: AppRadius.mdAll,
            border: Border.all(
              color: colors.dashed ? Colors.transparent : colors.border,
              width: colors.borderWidth,
            ),
          ),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: _iconSize, color: iconColor),
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: TextField(
                  controller: effectiveController,
                  focusNode: effectiveFocusNode,
                  enabled: enabled,
                  readOnly: readOnly,
                  obscureText: obscureText,
                  autofocus: autofocus,
                  maxLength: maxLength,
                  buildCounter: _hideCounter,
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  textCapitalization: textCapitalization,
                  autofillHints: autofillHints,
                  inputFormatters: inputFormatters,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  style: AppTypography.bodyMedium.copyWith(color: contentColor),
                  cursorColor: AppColors.primary,
                  decoration: InputDecoration.collapsed(
                    hintText: hintText,
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: enabled ? _placeholder : _disabledContent,
                    ),
                  ),
                ),
              ),
              if (hasTrailingAction)
                IconButton(
                  onPressed: enabled ? onTrailingIconPressed : null,
                  tooltip: trailingIconTooltip,
                  icon: Icon(trailingIcon, size: _iconSize),
                  style: IconButton.styleFrom(
                    fixedSize: const Size.square(_actionSize),
                    minimumSize: const Size.square(_actionSize),
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: iconColor,
                    disabledForegroundColor: _disabledContent,
                  ),
                )
              else if (trailingIcon != null) ...[
                const SizedBox(width: AppSpacing.sm),
                Icon(trailingIcon, size: _iconSize, color: iconColor),
              ],
            ],
          ),
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.xs,
      children: [
        if (label != null || topTrailingText != null)
          Row(
            spacing: AppSpacing.sm,
            children: [
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: _animationDuration,
                  curve: _animationCurve,
                  style: AppTypography.labelMedium.copyWith(
                    color: colors.label,
                  ),
                  child: Text(label ?? ''),
                ),
              ),
              if (topTrailingText != null)
                Text(
                  topTrailingText,
                  style: AppTypography.caption.copyWith(color: _placeholder),
                ),
            ],
          ),
        inputBox,
        if (bottomText != null)
          AnimatedDefaultTextStyle(
            duration: _animationDuration,
            curve: _animationCurve,
            style: AppTypography.caption.copyWith(
              color: errorText != null && enabled ? AppColors.error : _helper,
            ),
            child: Text(bottomText),
          ),
      ],
    );
  }

  _InputState _resolveState({required bool focused, required bool filled}) {
    if (!enabled) return _InputState.disabled;
    if (readOnly) return _InputState.readOnly;
    if (errorText != null) return _InputState.error;
    if (isSuccess) return _InputState.success;
    if (focused) return _InputState.focused;
    if (filled) return _InputState.filled;
    return _InputState.idle;
  }

  static _InputColors _resolveColors(_InputState state) {
    return switch (state) {
      _InputState.idle => const _InputColors(border: _borderDefault),
      _InputState.focused => const _InputColors(
        border: AppColors.primary,
        borderWidth: 2,
        label: AppColors.primary,
        shadow: [BoxShadow(color: _focusGlow, spreadRadius: 3)],
      ),
      _InputState.filled => const _InputColors(border: _borderFilled),
      _InputState.error => const _InputColors(
        background: _errorBackground,
        border: AppColors.error,
        borderWidth: 2,
        label: AppColors.error,
        shadow: [BoxShadow(color: _errorGlow, spreadRadius: 3)],
      ),
      _InputState.success => const _InputColors(
        background: _successBackground,
        border: AppColors.success,
        borderWidth: 2,
        label: AppColors.success,
      ),
      _InputState.disabled => const _InputColors(
        background: AppColors.background,
        border: _borderDisabled,
        label: _disabledContent,
      ),
      _InputState.readOnly => const _InputColors(
        background: _readOnlyBackground,
        border: _borderDefault,
        dashed: true,
      ),
    };
  }

  static Widget? _hideCounter(
    BuildContext context, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  }) => null;
}

enum _InputState { idle, focused, filled, error, success, disabled, readOnly }

class _InputColors {
  const _InputColors({
    required this.border,
    this.background = AppColors.surface,
    this.borderWidth = 1.5,
    this.label = AppColors.onSurface,
    this.shadow = const [],
    this.dashed = false,
  });

  final Color background;
  final Color border;
  final double borderWidth;
  final Color label;
  final List<BoxShadow> shadow;
  final bool dashed;
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  static const double _dashLength = 6;
  static const double _gapLength = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = AppRadius.mdAll
        .toRRect(Offset.zero & size)
        .deflate(strokeWidth / 2);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    for (final metric in (Path()..addRRect(rrect)).computeMetrics()) {
      for (var d = 0.0; d < metric.length; d += _dashLength + _gapLength) {
        canvas.drawPath(metric.extractPath(d, d + _dashLength), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}
