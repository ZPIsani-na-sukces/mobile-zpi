import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/auth/shared/controllers/auth_controller.dart';
import 'package:mobile_zpi/features/home/presentation/navigate_back_home.dart';
import 'package:mobile_zpi/features/home_widgets/controllers/widget_launch_controller.dart';
import 'package:mobile_zpi/features/home_widgets/data/home_widgets.dart';
import 'package:mobile_zpi/features/profile/controllers/home_address_controller.dart';
import 'package:mobile_zpi/features/profile/data/models/home_address.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';

class HomeWidgetLaunchListener extends HookConsumerWidget {
  const HomeWidgetLaunchListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // From the stored session, so a tap opens SOS even without network.
    final seniorId = ref.watch(
      authControllerProvider.select((auth) => auth.value?.user.userId),
    );

    useEffect(() {
      if (seniorId == null) return null;
      final subscription = ref.listenManual(widgetLaunchControllerProvider, (
        _,
        launch,
      ) {
        if (launch == null) return;
        // Deferred, as this also fires while the widget tree is building.
        Future.microtask(() {
          if (context.mounted) _open(context, ref, seniorId, launch);
        });
      }, fireImmediately: true);
      return subscription.close;
    }, [seniorId]);

    return child;
  }

  Future<void> _open(
    BuildContext context,
    WidgetRef ref,
    String seniorId,
    HomeWidgetLaunch launch,
  ) async {
    ref.read(widgetLaunchControllerProvider.notifier).consume();
    switch (launch) {
      case HomeWidgetLaunch.sos:
        final router = context.router.root;
        // A second SOS screen would send a second alert.
        if (router.isRouteActive(SosRoute.name)) return;
        unawaited(router.push(SosRoute(seniorId: seniorId)));
      case HomeWidgetLaunch.backHome:
        await _openBackHome(context, ref, seniorId);
    }
  }

  Future<void> _openBackHome(
    BuildContext context,
    WidgetRef ref,
    String seniorId,
  ) async {
    final HomeAddress? home;
    try {
      home = await ref.read(homeAddressControllerProvider(seniorId).future);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nie udało się wczytać adresu domu.')),
      );
      return;
    }
    if (!context.mounted) return;
    navigateBackHome(context, seniorId: seniorId, home: home);
  }
}
