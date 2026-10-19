import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

@pragma('vm:entry-point')
Future<void> locationTrackingHeadlessTask(bg.HeadlessEvent event) async {
  if (event.name != bg.Event.HEARTBEAT) return;
  try {
    await bg.BackgroundGeolocation.getCurrentPosition(
      samples: 1,
      persist: true,
    );
  } catch (e) {
    debugPrint('Headless heartbeat failed: $e');
  }
}
