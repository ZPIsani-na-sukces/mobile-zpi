import 'package:home_widget/home_widget.dart';

/// Shared with `ios/Runner/Runner.entitlements` and the widget extension.
const homeWidgetsAppGroup = 'group.pl.zpizsws.mobile';

/// Keys read by the native widgets on Android and iOS.
abstract final class HomeWidgetKeys {
  static const backHomeHasAddress = 'back_home_has_address';
}

enum HomeWidgetLaunch {
  sos('sos'),
  backHome('back-home');

  const HomeWidgetLaunch(this.host);

  final String host;

  static HomeWidgetLaunch? fromUri(Uri? uri) =>
      values.where((launch) => launch.host == uri?.host).firstOrNull;
}

Future<void> setUpHomeWidgets() =>
    HomeWidget.setAppGroupId(homeWidgetsAppGroup);

Future<void> saveBackHomeWidgetHasAddress(bool hasAddress) async {
  await HomeWidget.saveWidgetData(
    HomeWidgetKeys.backHomeHasAddress,
    hasAddress,
  );
  await HomeWidget.updateWidget(
    androidName: 'BackHomeWidgetProvider',
    iOSName: 'BackHomeWidget',
  );
}
