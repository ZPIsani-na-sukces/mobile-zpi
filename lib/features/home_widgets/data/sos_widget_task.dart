import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:home_widget/home_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/auth/shared/controllers/auth_controller.dart';
import 'package:mobile_zpi/features/home_widgets/data/home_widgets.dart';
import 'package:mobile_zpi/features/sos/data/sos_location.dart';
import 'package:mobile_zpi/features/sos/data/sos_repository.dart';

/// Sends SOS from the home screen widget without opening the app.
@pragma('vm:entry-point')
Future<void> sosWidgetTask(Uri? _) async {
  await HomeWidget.setAppGroupId(homeWidgetsAppGroup);
  if (await _isSending()) return;

  await HomeWidget.saveWidgetData(
    HomeWidgetKeys.sosSendingAt,
    DateTime.now().millisecondsSinceEpoch,
  );
  await saveSosWidgetStatus('Wysyłanie…');

  final container = ProviderContainer();
  final status = await _send(container);
  container.dispose();

  await HomeWidget.saveWidgetData<int>(HomeWidgetKeys.sosSendingAt, null);
  await saveSosWidgetStatus(status);
}

Future<String> _send(ProviderContainer container) async {
  try {
    final session = await container.read(authControllerProvider.future);
    if (session == null) return sosLoggedOutStatus;

    await container
        .read(sosRepositoryProvider)
        .trigger(
          seniorId: session.user.userId,
          triggeredAt: DateTime.now().toUtc(),
          position: await _readFix(),
        );
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return 'Wysłano o $hour:$minute';
  } catch (error) {
    debugPrint('Widget SOS failed: $error');
    return 'Nie wysłano. Dotknij ponownie';
  }
}

/// The widget runs in the background, so it never asks for permission and
/// sends without location when there is none. Android cuts the network of a
/// background app within seconds, so it takes the last fix instead of waiting
/// for a new one.
Future<SosFix?> _readFix() async {
  try {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }
    final position = await Geolocator.getLastKnownPosition();
    return position == null ? null : SosFix.fromPosition(position);
  } catch (error) {
    debugPrint('Widget SOS location failed: $error');
    return null;
  }
}

/// Ignores taps while the previous one is still sending.
Future<bool> _isSending() async {
  final sendingAt = await HomeWidget.getWidgetData<int>(
    HomeWidgetKeys.sosSendingAt,
  );
  if (sendingAt == null) return false;
  final startedAt = DateTime.fromMillisecondsSinceEpoch(sendingAt);
  return DateTime.now().difference(startedAt) < const Duration(minutes: 1);
}
