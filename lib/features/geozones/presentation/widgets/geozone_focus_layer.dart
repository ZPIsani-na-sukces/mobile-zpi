import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_zpi/features/geozones/data/models/geozone.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';

class GeozoneFocusLayer extends HookWidget {
  const GeozoneFocusLayer({super.key, required this.geozone});

  final Geozone? geozone;

  static const double _maxZoom = 18;
  static const EdgeInsets _padding = EdgeInsets.fromLTRB(
    AppSpacing.xl,
    AppSpacing.xxxl * 2,
    AppSpacing.xl,
    AppSpacing.xxxl * 6,
  );

  @override
  Widget build(BuildContext context) {
    final controller = MapController.of(context);
    final zone = geozone;

    useEffect(() {
      if (zone == null) return null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        final center = LatLng(zone.center.latitude, zone.center.longitude);
        const distance = Distance();
        controller.fitCamera(
          CameraFit.coordinates(
            coordinates: [
              for (final bearing in const [0.0, 90.0, 180.0, 270.0])
                distance.offset(center, zone.radiusMeters, bearing),
            ],
            padding: _padding,
            maxZoom: _maxZoom,
          ),
        );
      });
      return null;
    }, [zone?.zoneId]);

    return const SizedBox.shrink();
  }
}
