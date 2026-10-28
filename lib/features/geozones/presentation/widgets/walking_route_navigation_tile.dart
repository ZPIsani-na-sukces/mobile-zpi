import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/geozones/controllers/route_reroute_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/walking_route_progress_controller.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/map_cancel_route_button.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/map_show_whole_route_button.dart';
import 'package:mobile_zpi/features/geozones/utils/geozone_formatters.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

class WalkingRouteNavigationTile extends ConsumerWidget {
  const WalkingRouteNavigationTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(walkingRouteProgressProvider);
    final isRerouting = ref.watch(routeRerouteControllerProvider);
    if (progress == null) return const SizedBox.shrink();

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
              isRerouting ? 'Wyznaczam nową trasę…' : 'Do domu',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onSurface.withValues(alpha: 0.7),
              ),
            ),
            Text(
              formatWalkingDuration(progress.remainingSeconds),
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            Text(
              formatDistance(progress.remainingMeters),
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Row(
              spacing: AppSpacing.sm,
              children: [
                Expanded(child: MapShowWholeRouteButton()),
                Expanded(child: MapCancelRouteButton(label: 'Zakończ')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
