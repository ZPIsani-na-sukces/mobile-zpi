import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

abstract final class AppTheme {
  static final ThemeData standard = _build(AppColors.standard);
  static final ThemeData highContrast = _build(AppColors.highContrast);

  static ThemeData _build(AppColors colors) {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      secondary: colors.secondary,
      onSecondary: colors.onSecondary,
      // Selected M3 chips use the container slot; keep them blue.
      secondaryContainer: colors.primary,
      onSecondaryContainer: colors.onPrimary,
      error: colors.error,
      onError: colors.onError,
      surface: colors.surface,
      onSurface: colors.onSurface,
    );
    final textTheme = AppTypography.textTheme.apply(
      bodyColor: colors.onBackground,
      displayColor: colors.onBackground,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      extensions: [colors],
      fontFamily: AppTypography.fontFamily,
      textTheme: textTheme,
      scaffoldBackgroundColor: colors.background,
      canvasColor: colors.background,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: colors.surface,
        selectedItemColor: colors.primary,
        unselectedItemColor: colors.onSurface.withValues(alpha: 0.74),
        selectedIconTheme: const IconThemeData(size: 26),
        unselectedIconTheme: const IconThemeData(size: 26),
        selectedLabelStyle: AppTypography.labelSmall.copyWith(
          fontSize: 13,
          height: 16 / 13,
          fontWeight: AppTypography.bold,
          letterSpacing: 0,
        ),
        unselectedLabelStyle: AppTypography.labelSmall.copyWith(
          fontSize: 13,
          height: 16 / 13,
          fontWeight: AppTypography.regular,
          letterSpacing: 0,
        ),
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      // The default month label is onSurface at 60%, below 7:1.
      datePickerTheme: colors.isHighContrast
          ? DatePickerThemeData(subHeaderForegroundColor: colors.onSurface)
          : null,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colors.onSurface,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: colors.onPrimary,
        ),
        actionTextColor: colors.secondary,
        showCloseIcon: true,
        closeIconColor: colors.onPrimary,
        elevation: 4,
        insetPadding: const EdgeInsets.all(AppSpacing.md),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
      ),
    );
  }
}
