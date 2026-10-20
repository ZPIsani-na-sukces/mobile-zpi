import 'package:flutter/material.dart';
import 'package:mobile_zpi/features/geozones/data/models/geozone.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/geozone_info_row.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';

class GeozoneInfoTile extends StatelessWidget {
  const GeozoneInfoTile({
    super.key,
    required this.geozone,
    required this.onClose,
  });

  final Geozone geozone;
  final VoidCallback onClose;

  static const double _statusDotSize = 10;

  @override
  Widget build(BuildContext context) {
    final statusColor = geozone.isActive
        ? AppColors.geozoneActive
        : AppColors.geozoneInactive;

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.xlAll,
        boxShadow: AppShadows.lg,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              geozone.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            const Divider(height: AppSpacing.xl),
            GeozoneInfoRow(
              label: 'Status',
              value: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: AppSpacing.sm,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox.square(dimension: _statusDotSize),
                  ),
                  Text(geozone.isActive ? 'Aktywna' : 'Nieaktywna'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            GeozoneInfoRow(
              label: 'Promień',
              value: Text(_formatRadius(geozone.radiusMeters)),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton.primary(label: 'Zamknij', onPressed: onClose),
          ],
        ),
      ),
    );
  }

  String _formatRadius(double meters) {
    if (meters < 1000) return '${meters.round()} m';
    final kilometers = (meters / 1000).toStringAsFixed(1).replaceAll('.', ',');
    return '$kilometers km';
  }
}
