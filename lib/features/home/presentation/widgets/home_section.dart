import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

class HomeSection extends StatelessWidget {
  const HomeSection({
    super.key,
    required this.title,
    required this.child,
    this.actionLabel,
    this.onAction,
    this.actionKey,
  });

  final String title;
  final Widget child;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Key? actionKey;

  static const double _actionMinHeight = 48;
  static const double _chevronSize = 24;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final label = actionLabel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: _actionMinHeight),
          child: Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    title,
                    style: AppTypography.titleLarge.copyWith(
                      color: colors.onBackground,
                    ),
                  ),
                ),
              ),
              if (label != null && onAction != null)
                InkWell(
                  key: actionKey,
                  onTap: onAction,
                  borderRadius: AppRadius.mdAll,
                  highlightColor: colors.surfacePressed,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: _actionMinHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.sm),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            label,
                            style: AppTypography.labelLarge.copyWith(
                              color: colors.primary,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: _chevronSize,
                            color: colors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }
}
