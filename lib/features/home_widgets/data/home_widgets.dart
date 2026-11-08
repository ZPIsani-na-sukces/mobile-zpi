import 'package:home_widget/home_widget.dart';
import 'package:mobile_zpi/features/home_widgets/data/sos_widget_task.dart';

/// Shared with `ios/Runner/Runner.entitlements` and the widget extension.
const homeWidgetsAppGroup = 'group.com.example.mobileZpi';

/// Keys read by the native widgets on Android and iOS.
abstract final class HomeWidgetKeys {
  static const sosStatus = 'sos_status';
  static const sosSendingAt = 'sos_sending_at';
  static const signedIn = 'signed_in';
  static const hasHome = 'has_home';
}

/// Link the "Wróć do domu" widget opens the app with. The `homeWidget` query
/// lets the plugin tell it apart from other links on iOS.
const backHomeWidgetHost = 'back-home';

const sosLoggedOutStatus = 'Zaloguj się w aplikacji';

Future<void> setUpHomeWidgets() async {
  await HomeWidget.setAppGroupId(homeWidgetsAppGroup);
  await HomeWidget.registerInteractivityCallback(sosWidgetTask);
}

Future<void> saveSosWidgetStatus(String? status) async {
  await HomeWidget.saveWidgetData(HomeWidgetKeys.sosStatus, status);
  await HomeWidget.updateWidget(
    androidName: 'SosWidgetProvider',
    iOSName: 'SosWidget',
  );
}

/// Logged out, both widgets open the app instead of acting on their own.
Future<void> saveWidgetsLoggedOut() async {
  await HomeWidget.saveWidgetData(HomeWidgetKeys.signedIn, false);
  await saveSosWidgetStatus(sosLoggedOutStatus);
  await saveBackHomeWidgetHasHome(hasHome: false);
}

/// Redraws the SOS widget for a new session and drops the logged out hint.
Future<void> resetSosWidget() async {
  await HomeWidget.saveWidgetData(HomeWidgetKeys.signedIn, true);
  final status = await HomeWidget.getWidgetData<String>(
    HomeWidgetKeys.sosStatus,
  );
  await saveSosWidgetStatus(status == sosLoggedOutStatus ? null : status);
}

Future<void> saveBackHomeWidgetHasHome({required bool hasHome}) async {
  await HomeWidget.saveWidgetData(HomeWidgetKeys.hasHome, hasHome);
  await HomeWidget.updateWidget(
    androidName: 'BackHomeWidgetProvider',
    iOSName: 'BackHomeWidget',
  );
}

/// Links the app was opened with from a widget: the cold start one first,
/// then every tap while the app runs.
Stream<Uri> widgetLaunches() async* {
  final initial = await HomeWidget.initiallyLaunchedFromHomeWidget();
  if (initial != null) yield initial;
  await for (final uri in HomeWidget.widgetClicked) {
    if (uri != null) yield uri;
  }
}
