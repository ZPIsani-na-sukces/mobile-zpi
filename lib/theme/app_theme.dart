import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

class AppTheme {
  static const ColorScheme _colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    // Selected M3 chips use the container slot; keep them blue.
    secondaryContainer: AppColors.primary,
    onSecondaryContainer: AppColors.onPrimary,
    error: AppColors.error,
    onError: AppColors.onError,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
  );

  static ThemeData get light {
    final textTheme = AppTypography.textTheme.apply(
      bodyColor: AppColors.onBackground,
      displayColor: AppColors.onBackground,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: _colorScheme,
      fontFamily: AppTypography.fontFamily,
      textTheme: textTheme,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurface.withValues(alpha: 0.74),
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
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.onSurface,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.onPrimary,
        ),
        actionTextColor: AppColors.secondary,
        showCloseIcon: true,
        closeIconColor: AppColors.onPrimary,
        elevation: 4,
        insetPadding: const EdgeInsets.all(AppSpacing.md),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
      ),
    );
  }
}
