import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/map_circle_button.dart';

class MapBackButton extends StatelessWidget {
  const MapBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MapCircleButton(
      tooltip: 'Wstecz',
      onPressed: () => context.router.maybePop(),
      icon: const BackButtonIcon(),
    );
  }
}
