import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_zpi/features/geozones/controllers/walking_route_controller.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/geozone_map.dart';
import 'package:mobile_zpi/features/profile/controllers/home_address_controller.dart';
import 'package:mobile_zpi/features/profile/data/models/home_address.dart';
import 'package:mobile_zpi/widgets/app_button.dart';

class MapBackHomeButton extends ConsumerWidget {
  const MapBackHomeButton({super.key, required this.seniorId});

  final String seniorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressProvider = homeAddressControllerProvider(seniorId);
    final address = ref.watch(addressProvider);
    final isRouteLoading = ref.watch(walkingRouteControllerProvider).isLoading;

    return AppButton.primary(
      label: isRouteLoading ? 'Wyznaczam trasę…' : 'Wróć do domu',
      icon: Icons.home_outlined,
      onPressed: isRouteLoading
          ? null
          : switch (address) {
              AsyncData(value: final home) => () => _showRoute(
                context,
                ref,
                home,
              ),
              AsyncError() => () {
                ref.invalidate(addressProvider);
                _showMessage(context, 'Nie udało się wczytać adresu domu.');
              },
              AsyncLoading() => null,
            },
    );
  }

  Future<void> _showRoute(
    BuildContext context,
    WidgetRef ref,
    HomeAddress? home,
  ) async {
    if (home == null) {
      _showMessage(
        context,
        'Adres domu nie jest ustawiony. Poproś opiekuna o jego dodanie.',
      );
      return;
    }

    final mapController = MapController.of(context);
    final notifier = ref.read(walkingRouteControllerProvider.notifier);
    await notifier.fetch(
      LatLng(home.coordinates.latitude, home.coordinates.longitude),
    );
    if (!context.mounted) return;

    final route = ref.read(walkingRouteControllerProvider);
    if (route.hasError) {
      _showMessage(context, 'Nie udało się wyznaczyć trasy do domu.');
      return;
    }

    final points = route.value?.points ?? const [];
    if (points.length < 2) return;
    mapController.fitCamera(
      CameraFit.coordinates(
        coordinates: points,
        padding: GeozoneMap.routeFitPadding,
      ),
    );
  }

  void _showMessage(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
