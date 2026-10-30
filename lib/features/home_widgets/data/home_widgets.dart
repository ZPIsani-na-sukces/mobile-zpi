import 'package:home_widget/home_widget.dart';
import 'package:mobile_zpi/features/home_widgets/data/sos_widget_task.dart';

/// Shared with `ios/Runner/Runner.entitlements` and the widget extension.
const homeWidgetsAppGroup = 'group.com.example.mobileZpi';

/// Keys read by the native widgets on Android and iOS.
abstract final class HomeWidgetKeys {
  static const sosStatus = 'sos_status';
  static const sosSendingAt = 'sos_sending_at';
  static const backHomeUrl = 'back_home_url';
}

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

/// Redraws the SOS widget for a new session and drops the logged out hint.
Future<void> resetSosWidget() async {
  final status = await HomeWidget.getWidgetData<String>(
    HomeWidgetKeys.sosStatus,
  );
  await saveSosWidgetStatus(status == sosLoggedOutStatus ? null : status);
}

Future<void> saveBackHomeWidgetUrl(Uri? url) async {
  await HomeWidget.saveWidgetData(HomeWidgetKeys.backHomeUrl, url?.toString());
  await HomeWidget.updateWidget(
    androidName: 'BackHomeWidgetProvider',
    iOSName: 'BackHomeWidget',
  );
}
