import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/geozones/controllers/map_follow_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/route_reroute_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/walking_route_progress_controller.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/map_cancel_route_button.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/map_resume_navigation_button.dart';
import 'package:mobile_zpi/features/geozones/utils/geozone_formatters.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';

class WalkingRouteNavigationTile extends ConsumerWidget {
  const WalkingRouteNavigationTile({super.key});

  static const Duration _resumeAnimationDuration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(walkingRouteProgressProvider);
    final isRerouting = ref.watch(routeRerouteControllerProvider);
    final following = ref.watch(mapFollowControllerProvider);
    if (progress == null) return const SizedBox.shrink();

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
              isRerouting ? 'Wyznaczam nową trasę…' : 'Do domu',
              style: AppTypography.bodyMedium.copyWith(
                color: context.colors.onSurface.withValues(alpha: 0.7),
              ),
            ),
            Text(
              formatWalkingDuration(progress.remainingSeconds),
              style: AppTypography.headlineMedium.copyWith(
                color: context.colors.onSurface,
              ),
            ),
            Text(
              formatDistance(progress.remainingMeters),
              style: AppTypography.bodyLarge.copyWith(
                color: context.colors.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            LayoutBuilder(
              builder: (context, constraints) => Row(
                children: [
                  Expanded(
                    child: MapCancelRouteButton(
                      label: 'Zakończ',
                      variant: following
                          ? AppButtonVariant.primary
                          : AppButtonVariant.secondary,
                    ),
                  ),
                  AnimatedSize(
                    duration: _resumeAnimationDuration,
                    curve: Curves.easeOut,
                    alignment: Alignment.centerRight,
                    child: following
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.only(left: AppSpacing.sm),
                            child: SizedBox(
                              width: (constraints.maxWidth - AppSpacing.sm) / 2,
                              child: const MapResumeNavigationButton(),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
