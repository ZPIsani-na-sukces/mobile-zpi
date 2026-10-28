import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/geozones/controllers/current_location_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/geozones_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/route_navigation_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/route_reroute_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/walking_route_controller.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/geozone_info_tile.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/geozone_map.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/map_back_button.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/map_back_home_button.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/walking_route_navigation_tile.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/walking_route_preview_tile.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

@RoutePage()
class GeozoneView extends HookConsumerWidget {
  const GeozoneView({super.key, required this.seniorId});

  final String seniorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      return () => SystemChrome.setPreferredOrientations(const []);
    }, const []);

    final locationStatus = ref.watch(
      currentLocationControllerProvider.select(
        (state) => state.whenData((_) => true),
      ),
    );
    final geozones = ref.watch(geozonesControllerProvider(seniorId));
    final hasRoute = ref.watch(
      walkingRouteControllerProvider.select((state) => state.value != null),
    );
    final isNavigating = ref.watch(routeNavigationControllerProvider);
    ref.watch(routeRerouteControllerProvider);
    final selectedZoneId = useState<String?>(null);

    final zones = geozones.value ?? const [];
    final selectedZone = zones
        .where((zone) => zone.zoneId == selectedZoneId.value)
        .firstOrNull;

    final bottomPanel = switch (selectedZone) {
      final zone? => GeozoneInfoTile(
        geozone: zone,
        onClose: () => selectedZoneId.value = null,
      ),
      _ when isNavigating => const WalkingRouteNavigationTile(),
      _ when hasRoute => const WalkingRoutePreviewTile(),
      _ => null,
    };

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          switch (locationStatus) {
            AsyncData() => GeozoneMap(
              initialCenter: ref
                  .read(currentLocationControllerProvider)
                  .requireValue
                  .latLng,
              geozones: zones,
              selectedZoneId: selectedZone?.zoneId,
              onGeozoneTap: (zone) => selectedZoneId.value = zone.zoneId,
              bottomPanel: bottomPanel,
              bottomLeftAction: hasRoute
                  ? null
                  : MapBackHomeButton(seniorId: seniorId),
            ),
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
