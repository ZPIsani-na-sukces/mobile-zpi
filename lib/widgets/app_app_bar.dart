import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle = false,
  });

  final String title;
  final List<Widget>? actions;
  final bool centerTitle;

  static const double _height = 80;

  @override
  Size get preferredSize => const Size.fromHeight(_height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: _height,
      backgroundColor: context.colors.surface,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      shape: Border(
        bottom: BorderSide(
          color: context.colors.outline,
          width: context.colors.isHighContrast ? 2 : 1,
        ),
      ),
      titleSpacing: AppSpacing.md,
      centerTitle: centerTitle,
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.headlineMedium.copyWith(
          color: context.colors.onBackground,
        ),
      ),
      actions: actions,
    );
  }
}
