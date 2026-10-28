import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/geozones/controllers/walking_route_controller.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/geozone_info_row.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/map_cancel_route_button.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/map_start_navigation_button.dart';
import 'package:mobile_zpi/features/geozones/utils/geozone_formatters.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';

class WalkingRoutePreviewTile extends ConsumerWidget {
  const WalkingRoutePreviewTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(walkingRouteControllerProvider).value;
    if (route == null) return const SizedBox.shrink();

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
              'Trasa do domu',
              style: AppTypography.titleLarge.copyWith(
                color: context.colors.onSurface,
              ),
            ),
            const Divider(height: AppSpacing.xl),
            GeozoneInfoRow(
              label: 'Czas dojścia',
              value: Text(formatWalkingDuration(route.durationSeconds)),
            ),
            const SizedBox(height: AppSpacing.sm),
            GeozoneInfoRow(
              label: 'Dystans',
              value: Text(formatDistance(route.distanceMeters)),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Row(
              spacing: AppSpacing.sm,
              children: [
                Expanded(
                  child: MapCancelRouteButton(
                    label: 'Anuluj',
                    variant: AppButtonVariant.secondary,
                  ),
                ),
                Expanded(child: MapStartNavigationButton()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
