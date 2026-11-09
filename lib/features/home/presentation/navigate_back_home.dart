import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_zpi/features/profile/data/models/home_address.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';

void navigateBackHome(
  BuildContext context, {
  required String seniorId,
  required HomeAddress? home,
}) {
  if (home == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Adres domu nie jest ustawiony. Poproś opiekuna o jego dodanie.',
        ),
      ),
    );
    return;
  }
  final coordinates = home.coordinates;
  context.router.push(
    GeozoneRoute(
      seniorId: seniorId,
      navigateTo: LatLng(coordinates.latitude, coordinates.longitude),
    ),
  );
}
