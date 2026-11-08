import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_zpi/features/geozones/controllers/map_follow_controller.dart';
import 'package:mobile_zpi/features/geozones/controllers/route_navigation_controller.dart';
import 'package:mobile_zpi/features/geozones/data/models/geozone.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/current_location_marker_layer.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/geozone_circle_layer.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/home_marker_layer.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/map_attribution.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/map_center_location_button.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/map_compass.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/map_show_whole_route_button.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/route_arrival_listener.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/walking_route_layer.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';

class GeozoneMap extends ConsumerWidget {
  const GeozoneMap({
    super.key,
    required this.seniorId,
    required this.initialCenter,
    this.geozones = const [],
    this.selectedZoneId,
    this.onGeozoneTap,
    this.bottomPanel,
    this.bottomLeftAction,
  });

  final String seniorId;
  final LatLng initialCenter;
  final List<Geozone> geozones;
  final String? selectedZoneId;
  final ValueChanged<Geozone>? onGeozoneTap;
  final Widget? bottomPanel;
  final Widget? bottomLeftAction;

  static const double initialZoom = 16;
  static const double navigationZoom = 17.5;
  static const EdgeInsets routeFitPadding = EdgeInsets.all(AppSpacing.xxxl);
  static const Duration _panelAnimationDuration = Duration(milliseconds: 350);
  static const Offset _panelSlideOffset = Offset(0, 0.25);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNavigating = ref.watch(routeNavigationControllerProvider);

    return FlutterMap(
      options: MapOptions(
        initialCenter: initialCenter,
        initialZoom: initialZoom,
        onPositionChanged: (_, hasGesture) {
          if (!hasGesture) return;
          ref.read(mapFollowControllerProvider.notifier).pause();
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'pl.edu.pwr.student.senioro_zpi',
        ),
        GeozoneCircleLayer(
          geozones: geozones,
          selectedZoneId: selectedZoneId,
          onGeozoneTap: onGeozoneTap,
        ),
        const WalkingRouteLayer(),
        HomeMarkerLayer(seniorId: seniorId),
        const CurrentLocationMarkerLayer(),
        const RouteArrivalListener(),
        const MapAttribution(),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Align(
                    alignment: Alignment.centerRight,
                    child: MapCompass(),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ?bottomLeftAction,
                      const Spacer(),
                      if (isNavigating)
                        const MapShowWholeRouteButton()
                      else
                        const MapCenterLocationButton(),
                    ],
                  ),
                  AnimatedSize(
                    duration: _panelAnimationDuration,
                    curve: Curves.easeOut,
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    child: AnimatedSwitcher(
                      duration: _panelAnimationDuration,
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      layoutBuilder: (currentChild, previousChildren) => Stack(
                        fit: StackFit.passthrough,
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomCenter,
                        children: [
                          for (final child in previousChildren)
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: child,
                            ),
                          ?currentChild,
                        ],
                      ),
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween(
                            begin: _panelSlideOffset,
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      ),
                      child: bottomPanel == null
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(
                                top: AppSpacing.md,
                              ),
                              child: bottomPanel,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
