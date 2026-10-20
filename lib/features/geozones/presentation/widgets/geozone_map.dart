import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_zpi/features/geozones/data/models/geozone.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/current_location_marker.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/geozone_circle_layer.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/map_attribution.dart';

class GeozoneMap extends StatelessWidget {
  const GeozoneMap({
    super.key,
    required this.position,
    this.geozones = const [],
  });

  final LatLng position;
  final List<Geozone> geozones;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(initialCenter: position, initialZoom: 16),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'pl.edu.pwr.student.senioro_zpi',
        ),
        GeozoneCircleLayer(geozones: geozones),
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
      ],
    );
  }
}
