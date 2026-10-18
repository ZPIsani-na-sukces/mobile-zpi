import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/home/controllers/home_controller.dart';
import 'package:mobile_zpi/features/home/data/models/home_overview.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/back_scaffold.dart';

@RoutePage()
class GeozonePreviewView extends ConsumerWidget {
  const GeozonePreviewView({super.key, required this.seniorId});

  final String seniorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeControllerProvider(seniorId));

    return BackScaffold(
      title: 'Geostrefy',
      body: switch (home) {
        AsyncData(value: final overview) =>
          overview.zones.isEmpty
              ? const Center(child: Text('Brak ustawionych geostref.'))
              : ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    Text(
                      'Bezpieczne strefy ustawione przez opiekuna.',
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.onBackground,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    for (final zone in overview.zones) ...[
                      _ZonePreview(zone: zone),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ],
                ),
        AsyncError() => const Center(
          child: Text('Nie udało się wczytać geostref.'),
        ),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _ZonePreview extends StatelessWidget {
  const _ZonePreview({required this.zone});

  final HomeZone zone;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.15),
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: const Icon(Icons.place, color: AppColors.primary),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                zone.name,
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.onBackground,
                ),
              ),
              Text(
                'Promień ${zone.radiusMeters.round()} m',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
