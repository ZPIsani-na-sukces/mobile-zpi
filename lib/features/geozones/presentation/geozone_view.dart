import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_zpi/features/geozones/controllers/current_location_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/geozones_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/route_navigation_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/route_reroute_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/walking_route_controller.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/geozone_info_tile.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/geozone_map.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/location_loading.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/location_unavailable.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/map_back_button.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/map_back_home_button.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/walking_route_navigation_tile.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/walking_route_preview_tile.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';

@RoutePage()
class GeozoneView extends HookConsumerWidget {
  const GeozoneView({
    super.key,
    required this.seniorId,
    this.navigateTo,
    this.initialZoneId,
  });

  final String seniorId;
  final LatLng? navigateTo;
  final String? initialZoneId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      return () => SystemChrome.setPreferredOrientations(const []);
    }, const []);

    useEffect(() {
      final destination = navigateTo;
      if (destination != null) _startNavigation(context, ref, destination);
      return null;
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
    final selectedZoneId = useState(initialZoneId);

    final zones = geozones.value ?? const [];
    final selectedZone = zones
        .where((zone) => zone.zoneId == selectedZoneId.value)
        .firstOrNull;
    final focusedZone = zones
        .where((zone) => zone.zoneId == initialZoneId)
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
              seniorId: seniorId,
              initialCenter: ref
                  .read(currentLocationControllerProvider)
                  .requireValue
                  .latLng,
              geozones: zones,
              selectedZoneId: selectedZone?.zoneId,
              focusedZone: focusedZone,
              onGeozoneTap: (zone) => selectedZoneId.value = zone.zoneId,
              bottomPanel: bottomPanel,
              bottomLeftAction: hasRoute
                  ? null
                  : MapBackHomeButton(seniorId: seniorId),
            ),
            AsyncError() => LocationUnavailable(
              onRetry: () => ref.invalidate(
                currentLocationControllerProvider,
                asReload: true,
              ),
              onOpenSettings: Geolocator.openLocationSettings,
            ),
            AsyncLoading() => const LocationLoading(),
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

  Future<void> _startNavigation(
    BuildContext context,
    WidgetRef ref,
    LatLng destination,
  ) async {
    final LatLng origin;
    try {
      origin = (await ref.read(currentLocationControllerProvider.future))
          .latLng;
    } catch (_) {
      return;
    }
    if (!context.mounted) return;

    await ref
        .read(walkingRouteControllerProvider.notifier)
        .fetch(destination, origin: origin);
    if (!context.mounted) return;

    if (ref.read(walkingRouteControllerProvider).hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nie udało się wyznaczyć trasy do domu.')),
      );
      return;
    }
    ref.read(routeNavigationControllerProvider.notifier).start();
  }
}
