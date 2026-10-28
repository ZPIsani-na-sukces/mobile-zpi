import 'package:flutter/material.dart';
import 'package:mobile_zpi/features/geozones/data/models/geozone.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/geozone_info_row.dart';
import 'package:mobile_zpi/features/geozones/utils/geozone_formatters.dart';
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
        ? context.colors.geozoneActive
        : context.colors.geozoneInactive;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: context.colors.cardBorder,
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
                color: context.colors.onSurface,
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
              value: Text(formatDistance(geozone.radiusMeters)),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton.primary(label: 'Zamknij', onPressed: onClose),
          ],
        ),
      ),
    );
  }
}
