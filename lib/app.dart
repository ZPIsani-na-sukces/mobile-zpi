import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_zpi/features/auth/shared/controllers/auth_controller.dart';
import 'package:mobile_zpi/features/home_widgets/data/home_widgets.dart';
import 'package:mobile_zpi/features/profile/controllers/accessibility_controller.dart';
import 'package:mobile_zpi/features/profile/controllers/home_address_controller.dart';
import 'package:mobile_zpi/router/app_router.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/theme/app_theme.dart';

class MyApp extends HookConsumerWidget {
  MyApp({super.key, required ProviderContainer container})
    : _appRouter = AppRouter(
        isSignedIn: () => container.read(authControllerProvider).value != null,
      );

  final AppRouter _appRouter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authControllerProvider.select((auth) => auth.value != null), (
      wasSignedIn,
      isSignedIn,
    ) {
      if (wasSignedIn == true && !isSignedIn) {
        _appRouter.replaceAll([const LoginRoute()]);
      }
    });

    useEffect(() {
      final launches = widgetLaunches().listen((uri) {
        if (uri.host == backHomeWidgetHost) unawaited(_openBackHome(ref));
      });
      return launches.cancel;
    }, const []);

    final highContrast =
        ref.watch(highContrastControllerProvider).value ?? false;

    return MaterialApp.router(
      theme: AppTheme.standard,
      // The app has no dark mode, so the dark slot holds high contrast.
      darkTheme: AppTheme.highContrast,
      themeMode: highContrast ? ThemeMode.dark : ThemeMode.light,
      routerConfig: _appRouter.config(),
    );
  }

  /// Opens the walk home the "Wróć do domu" widget asks for. Signed out, the
  /// router guard already shows login, and without a home address the widget
  /// says so, so the app just opens.
  Future<void> _openBackHome(WidgetRef ref) async {
    final seniorId = ref.read(authControllerProvider).value?.user.userId;
    if (seniorId == null) return;
    final home = await ref.read(homeAddressControllerProvider(seniorId).future);
    if (home == null) return;
    // On a cold start the link can come before the router shows Home.
    await WidgetsBinding.instance.endOfFrame;
    final coordinates = home.coordinates;
    unawaited(
      _appRouter.push(
        GeozoneRoute(
          seniorId: seniorId,
          navigateTo: LatLng(coordinates.latitude, coordinates.longitude),
        ),
      ),
    );
  }
}
