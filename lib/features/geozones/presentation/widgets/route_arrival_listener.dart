import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/geozones/controllers/route_arrival_controller.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/home_reached_dialog.dart';
import 'package:mobile_zpi/features/geozones/utils/end_walking_route.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';

class RouteArrivalListener extends ConsumerWidget {
  const RouteArrivalListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(routeArrivalControllerProvider, (previous, hasArrived) async {
      if (!hasArrived || previous == true) return;

      endWalkingRoute(ref, MapController.of(context));
      final goHome = await showDialog<bool>(
        context: context,
        builder: (_) => const HomeReachedDialog(),
      );
      if (goHome != true || !context.mounted) return;

      await context.router.navigate(const AppRoute(children: [HomeRoute()]));
    });

    return const SizedBox.shrink();
  }
}
