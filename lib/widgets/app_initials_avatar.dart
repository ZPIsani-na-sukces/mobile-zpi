import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

class AppInitialsAvatar extends StatelessWidget {
  const AppInitialsAvatar({super.key, required this.name})
    : size = 56,
      textStyle = AppTypography.titleMedium;

  const AppInitialsAvatar.small({super.key, required this.name})
    : size = 44,
      textStyle = AppTypography.titleSmall;

  final String name;
  final double size;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part.characters.first)
        .join()
        .toUpperCase();

    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.colors.primary.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Text(
          initials,
          style: textStyle.copyWith(color: context.colors.primary),
        ),
      ),
    );
  }
}
