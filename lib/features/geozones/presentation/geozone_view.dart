import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/geozones/controllers/current_location_controller.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/geozone_map.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/map_back_button.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

@RoutePage()
class GeozoneView extends ConsumerWidget {
  const GeozoneView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(currentLocationControllerProvider);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          switch (location) {
            AsyncData(value: final position) => GeozoneMap(position: position),
            AsyncError() => Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  'Nie udało się odczytać lokalizacji. Sprawdź, czy lokalizacja jest włączona.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.onBackground,
                  ),
                ),
              ),
            ),
            AsyncLoading() => const Center(child: CircularProgressIndicator()),
          },
          Positioned(
            top: MediaQuery.paddingOf(context).top + AppSpacing.md,
            left: AppSpacing.md,
            child: const MapBackButton(),
          ),
        ],
      ),
    );
  }
}
