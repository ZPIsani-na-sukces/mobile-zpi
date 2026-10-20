import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/app.dart';
import 'package:mobile_zpi/features/auth/shared/controllers/auth_controller.dart';
import 'package:mobile_zpi/features/home_widgets/controllers/home_widgets_controller.dart';
import 'package:mobile_zpi/features/home_widgets/data/home_widgets.dart';
import 'package:mobile_zpi/features/location_tracking/controllers/location_tracking_controller.dart';
import 'package:mobile_zpi/features/location_tracking/data/location_tracking_headless_task.dart';
import 'package:mobile_zpi/features/profile/controllers/accessibility_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  await container.read(authControllerProvider.future);
  await container.read(highContrastControllerProvider.future);
  container.read(locationTrackingControllerProvider);
  await setUpHomeWidgets().catchError(
    (Object e) => debugPrint('Home widgets setup failed: $e'),
  );
  // Listened, not read: Riverpod only rebuilds listened providers, so the
  // widgets follow login and logout.
  container.listen(homeWidgetsControllerProvider, (_, _) {});

  runApp(UncontrolledProviderScope(container: container, child: MyApp()));
  await bg.BackgroundGeolocation.registerHeadlessTask(
    locationTrackingHeadlessTask,
  );
}
