import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:mobile_zpi/features/home_widgets/data/home_widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'widget_launch_controller.g.dart';

@Riverpod(keepAlive: true)
class WidgetLaunchController extends _$WidgetLaunchController {
  @override
  HomeWidgetLaunch? build() {
    final subscription = HomeWidget.widgetClicked.listen(
      _receive,
      onError: (Object e) => debugPrint('Widget click failed: $e'),
    );
    ref.onDispose(subscription.cancel);
    return null;
  }

  Future<void> readInitialLaunch() async {
    try {
      _receive(await HomeWidget.initiallyLaunchedFromHomeWidget());
    } catch (e) {
      debugPrint('Widget launch check failed: $e');
    }
  }

  void _receive(Uri? uri) {
    final launch = HomeWidgetLaunch.fromUri(uri);
    if (launch != null) state = launch;
  }

  void consume() => state = null;
}
