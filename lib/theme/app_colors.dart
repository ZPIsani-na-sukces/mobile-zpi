import 'package:flutter/material.dart';

/// Color tokens from the design system, read with `context.colors`.
///
/// [standard] is the palette from `design.md`. [highContrast] keeps every
/// text pair at 7:1 or more (WCAG 1.4.6, level AAA) and every UI boundary,
/// icon and state indicator at 4.5:1 or more (WCAG 1.4.11 asks for 3:1).
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.isHighContrast,
    required this.primary,
    required this.primaryVariant,
    required this.secondary,
    required this.secondaryVariant,
    required this.background,
    required this.surface,
    required this.success,
    required this.warning,
    required this.error,
    required this.onPrimary,
    required this.onSecondary,
    required this.onBackground,
    required this.onSurface,
    required this.onSuccess,
    required this.onWarning,
    required this.onError,
    required this.disabled,
    required this.onDisabled,
    required this.surfacePressed,
    required this.outline,
    required this.inputBorder,
    required this.inputBorderFilled,
    required this.inputBorderDisabled,
    required this.inputContentDisabled,
    required this.inputPlaceholder,
    required this.inputHelper,
    required this.inputErrorBackground,
    required this.inputSuccessBackground,
    required this.inputReadOnlyBackground,
    required this.inputFocusGlow,
    required this.inputErrorGlow,
    required this.geozoneActive,
    required this.geozoneActiveFill,
    required this.geozoneInactive,
    required this.geozoneInactiveFill,
  });

  static const AppColors standard = AppColors(
    isHighContrast: false,
    primary: Color(0xFF0067B8),
    primaryVariant: Color(0xFF004E8C),
    secondary: Color(0xFFC9950A),
    secondaryVariant: Color(0xFF997107),
    background: Color(0xFFF4F6F6),
    surface: Color(0xFFFFFFFF),
    success: Color(0xFF2E7D32),
    warning: Color(0xFFFFCC00),
    error: Color(0xFFC62828),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFFFFFFFF),
    onBackground: Color(0xFF1C2833),
    onSurface: Color(0xFF1C2833),
    onSuccess: Color(0xFFFFFFFF),
    onWarning: Color(0xFF1C2833),
    onError: Color(0xFFFFFFFF),
    disabled: Color(0xFFE0E0E0),
    onDisabled: Color(0xFF9E9E9E),
    surfacePressed: Color(0xFFEAECEE),
    outline: Color(0xFFE0E0E0),
    inputBorder: Color(0xFFCBD5E1),
    inputBorderFilled: Color(0xFF64748B),
    inputBorderDisabled: Color(0xFFE2E8F0),
    inputContentDisabled: Color(0xFF94A3B8),
    inputPlaceholder: Color(0xFF718096),
    inputHelper: Color(0xFF596573),
    inputErrorBackground: Color(0xFFFFF5F5),
    inputSuccessBackground: Color(0xFFF6FFF8),
    inputReadOnlyBackground: Color(0xFFF8FAFC),
    inputFocusGlow: Color(0x330067B8),
    inputErrorGlow: Color(0x26C62828),
    geozoneActive: Color(0xFF16A34A),
    geozoneActiveFill: Color(0xFF22C55E),
    geozoneInactive: Color(0xFF9CA3AF),
    geozoneInactiveFill: Color(0xFFE5E7EB),
  );

  static const AppColors highContrast = AppColors(
    isHighContrast: true,
    primary: Color(0xFF003D7A),
    primaryVariant: Color(0xFF00264D),
    secondary: Color(0xFF6B4D00),
    secondaryVariant: Color(0xFF4A3500),
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    success: Color(0xFF1B5E20),
    warning: Color(0xFF8A5A00),
    error: Color(0xFFA31515),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFFFFFFFF),
    onBackground: Color(0xFF000000),
    onSurface: Color(0xFF000000),
    onSuccess: Color(0xFFFFFFFF),
    onWarning: Color(0xFFFFFFFF),
    onError: Color(0xFFFFFFFF),
    disabled: Color(0xFFD6D6D6),
    onDisabled: Color(0xFF3D3D3D),
    surfacePressed: Color(0xFFD6D6D6),
    outline: Color(0xFF000000),
    inputBorder: Color(0xFF000000),
    inputBorderFilled: Color(0xFF000000),
    inputBorderDisabled: Color(0xFF757575),
    inputContentDisabled: Color(0xFF575757),
    inputPlaceholder: Color(0xFF575757),
    inputHelper: Color(0xFF333333),
    inputErrorBackground: Color(0xFFFFF5F5),
    inputSuccessBackground: Color(0xFFF6FFF8),
    inputReadOnlyBackground: Color(0xFFF2F2F2),
    inputFocusGlow: Color(0x4D003D7A),
    inputErrorGlow: Color(0x40A31515),
    geozoneActive: Color(0xFF0B6623),
    geozoneActiveFill: Color(0xFF0B6623),
    geozoneInactive: Color(0xFF4D4D4D),
    geozoneInactiveFill: Color(0xFF4D4D4D),
  );

  final bool isHighContrast;

  final Color primary;
  final Color primaryVariant;
  final Color secondary;
  final Color secondaryVariant;
  final Color background;
  final Color surface;
  final Color success;
  final Color warning;
  final Color error;

  final Color onPrimary;
  final Color onSecondary;
  final Color onBackground;
  final Color onSurface;
  final Color onSuccess;
  final Color onWarning;
  final Color onError;

  final Color disabled;
  final Color onDisabled;
  final Color surfacePressed;

  /// Dividers and, in high contrast, card outlines.
  final Color outline;

  final Color inputBorder;
  final Color inputBorderFilled;
  final Color inputBorderDisabled;
  final Color inputContentDisabled;
  final Color inputPlaceholder;

  /// Helper text and icons inside input fields.
  final Color inputHelper;
  final Color inputErrorBackground;
  final Color inputSuccessBackground;
  final Color inputReadOnlyBackground;
  final Color inputFocusGlow;
  final Color inputErrorGlow;

  final Color geozoneActive;
  final Color geozoneActiveFill;
  final Color geozoneInactive;
  final Color geozoneInactiveFill;

  /// Outline for cards and floating tiles. The standard palette separates them
  /// with a shadow only, which is too faint for high contrast.
  Border? get cardBorder =>
      isHighContrast ? Border.all(color: outline, width: 2) : null;

  // Palettes are const, so the copy is the same instance.
  @override
  AppColors copyWith() => this;

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;

    return AppColors(
      isHighContrast: t < 0.5 ? isHighContrast : other.isHighContrast,
      primary: mix(primary, other.primary),
      primaryVariant: mix(primaryVariant, other.primaryVariant),
      secondary: mix(secondary, other.secondary),
      secondaryVariant: mix(secondaryVariant, other.secondaryVariant),
      background: mix(background, other.background),
      surface: mix(surface, other.surface),
      success: mix(success, other.success),
      warning: mix(warning, other.warning),
      error: mix(error, other.error),
      onPrimary: mix(onPrimary, other.onPrimary),
      onSecondary: mix(onSecondary, other.onSecondary),
      onBackground: mix(onBackground, other.onBackground),
      onSurface: mix(onSurface, other.onSurface),
      onSuccess: mix(onSuccess, other.onSuccess),
      onWarning: mix(onWarning, other.onWarning),
      onError: mix(onError, other.onError),
      disabled: mix(disabled, other.disabled),
      onDisabled: mix(onDisabled, other.onDisabled),
      surfacePressed: mix(surfacePressed, other.surfacePressed),
      outline: mix(outline, other.outline),
      inputBorder: mix(inputBorder, other.inputBorder),
      inputBorderFilled: mix(inputBorderFilled, other.inputBorderFilled),
      inputBorderDisabled: mix(inputBorderDisabled, other.inputBorderDisabled),
      inputContentDisabled: mix(
        inputContentDisabled,
        other.inputContentDisabled,
      ),
      inputPlaceholder: mix(inputPlaceholder, other.inputPlaceholder),
      inputHelper: mix(inputHelper, other.inputHelper),
      inputErrorBackground: mix(
        inputErrorBackground,
        other.inputErrorBackground,
      ),
      inputSuccessBackground: mix(
        inputSuccessBackground,
        other.inputSuccessBackground,
      ),
      inputReadOnlyBackground: mix(
        inputReadOnlyBackground,
        other.inputReadOnlyBackground,
      ),
      inputFocusGlow: mix(inputFocusGlow, other.inputFocusGlow),
      inputErrorGlow: mix(inputErrorGlow, other.inputErrorGlow),
      geozoneActive: mix(geozoneActive, other.geozoneActive),
      geozoneActiveFill: mix(geozoneActiveFill, other.geozoneActiveFill),
      geozoneInactive: mix(geozoneInactive, other.geozoneInactive),
      geozoneInactiveFill: mix(geozoneInactiveFill, other.geozoneInactiveFill),
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
