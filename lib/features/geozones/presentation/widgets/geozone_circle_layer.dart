import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_zpi/features/geozones/data/models/geozone.dart';
import 'package:mobile_zpi/theme/app_colors.dart';

class GeozoneCircleLayer extends StatelessWidget {
  const GeozoneCircleLayer({super.key, required this.geozones});

  final List<Geozone> geozones;

  @override
  Widget build(BuildContext context) {
    return CircleLayer(
      circles: [
        for (final zone in geozones)
          CircleMarker(
            point: LatLng(zone.center.latitude, zone.center.longitude),
            radius: zone.radiusMeters,
            useRadiusInMeter: true,
            color:
                (zone.isActive
                        ? AppColors.geozoneActiveFill
                        : AppColors.geozoneInactiveFill)
                    .withValues(alpha: 0.25),
            borderColor: zone.isActive
                ? AppColors.geozoneActive
                : AppColors.geozoneInactive,
            borderStrokeWidth: 2,
          ),
      ],
    );
  }
}
