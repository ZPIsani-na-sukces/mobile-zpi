import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_zpi/features/geozones/data/models/geozone.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/current_location_marker.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/geozone_circle_layer.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/map_attribution.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/map_compass.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';

class GeozoneMap extends StatelessWidget {
  const GeozoneMap({
    super.key,
    required this.position,
    this.geozones = const [],
    this.selectedZoneId,
    this.onGeozoneTap,
    this.bottomPanel,
  });

  final LatLng position;
  final List<Geozone> geozones;
  final String? selectedZoneId;
  final ValueChanged<Geozone>? onGeozoneTap;
  final Widget? bottomPanel;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(initialCenter: position, initialZoom: 16),
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
        MarkerLayer(
          markers: [
            Marker(
              point: position,
              width: CurrentLocationMarker.size,
              height: CurrentLocationMarker.size,
              child: const CurrentLocationMarker(),
            ),
          ],
        ),
        const MapAttribution(),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: AppSpacing.md,
                children: [
                  const Align(
                    alignment: Alignment.centerRight,
                    child: MapCompass(),
                  ),
                  ?bottomPanel,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
