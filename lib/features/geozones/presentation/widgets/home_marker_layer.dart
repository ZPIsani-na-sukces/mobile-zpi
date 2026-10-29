import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/home_marker.dart';
import 'package:mobile_zpi/features/profile/controllers/home_address_controller.dart';

class HomeMarkerLayer extends ConsumerWidget {
  const HomeMarkerLayer({super.key, required this.seniorId});

  final String seniorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeAddressControllerProvider(seniorId)).value;
    if (home == null) return const SizedBox.shrink();

    return MarkerLayer(
      markers: [
        Marker(
          point: LatLng(home.coordinates.latitude, home.coordinates.longitude),
          width: HomeMarker.size,
          height: HomeMarker.size,
          rotate: true,
          child: const HomeMarker(),
        ),
      ],
    );
  }
}
