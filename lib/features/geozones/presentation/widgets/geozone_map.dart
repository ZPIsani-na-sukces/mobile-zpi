import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/current_location_marker.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/map_attribution.dart';

class GeozoneMap extends StatelessWidget {
  const GeozoneMap({super.key, required this.position});

  final LatLng position;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(initialCenter: position, initialZoom: 16),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'pl.edu.pwr.student.senioro_zpi',
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
      ],
    );
  }
}
