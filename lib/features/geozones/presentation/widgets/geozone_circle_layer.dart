import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_zpi/features/geozones/data/models/geozone.dart';
import 'package:mobile_zpi/theme/app_colors.dart';

class GeozoneCircleLayer extends HookWidget {
  const GeozoneCircleLayer({
    super.key,
    required this.geozones,
    this.selectedZoneId,
    this.onGeozoneTap,
  });

  final List<Geozone> geozones;
  final String? selectedZoneId;
  final ValueChanged<Geozone>? onGeozoneTap;

  static const double _fillAlpha = 0.25;
  static const double _selectedFillAlpha = 0.4;
  static const double _dimmedFillAlpha = 0.15;
  static const double _borderWidth = 2;
  static const double _selectedBorderWidth = 4;

  @override
  Widget build(BuildContext context) {
    final hitNotifier = useValueNotifier<LayerHitResult<Geozone>?>(null);

    final orderedZones = [
      for (final zone in geozones)
        if (zone.zoneId != selectedZoneId) zone,
      for (final zone in geozones)
        if (zone.zoneId == selectedZoneId) zone,
    ];

    return GestureDetector(
      onTap: () {
        final zone = hitNotifier.value?.hitValues.firstOrNull;
        if (zone != null) onGeozoneTap?.call(zone);
      },
      child: CircleLayer<Geozone>(
        hitNotifier: hitNotifier,
        circles: [
          for (final zone in orderedZones)
            CircleMarker(
              point: LatLng(zone.center.latitude, zone.center.longitude),
              radius: zone.radiusMeters,
              useRadiusInMeter: true,
              hitValue: zone,
              color:
                  (zone.isActive
                          ? context.colors.geozoneActiveFill
                          : context.colors.geozoneInactiveFill)
                      .withValues(
                        alpha: switch (selectedZoneId) {
                          null => _fillAlpha,
                          final id when id == zone.zoneId => _selectedFillAlpha,
                          _ => _dimmedFillAlpha,
                        },
                      ),
              borderColor: zone.isActive
                  ? context.colors.geozoneActive
                  : context.colors.geozoneInactive,
              borderStrokeWidth: zone.zoneId == selectedZoneId
                  ? _selectedBorderWidth
                  : _borderWidth,
            ),
        ],
      ),
    );
  }
}
