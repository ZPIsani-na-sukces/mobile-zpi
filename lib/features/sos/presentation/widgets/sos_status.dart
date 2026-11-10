import 'package:flutter/material.dart';
import 'package:mobile_zpi/features/sos/presentation/widgets/sos_status_icon.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

class SosStatus extends StatelessWidget {
  const SosStatus({
    super.key,
    required this.icon,
    required this.color,
    required this.onColor,
    required this.title,
    required this.body,
    this.busy = false,
  });

  final IconData icon;
  final Color color;
  final Color onColor;
  final String title;
  final String body;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Column(
        children: [
          SosStatusIcon(icon: icon, color: color, onColor: onColor, busy: busy),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.headlineSmall.copyWith(
              color: context.colors.onBackground,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            body,
            textAlign: TextAlign.center,
            style: AppTypography.titleLarge.copyWith(
              fontWeight: AppTypography.regular,
              color: context.colors.onBackground,
            ),
          ),
        ],
      ),
    );
  }
}
