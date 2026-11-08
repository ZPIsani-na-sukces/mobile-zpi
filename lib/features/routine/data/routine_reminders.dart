import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_zpi/features/routine/data/models/task_occurrence.dart';
import 'package:mobile_zpi/features/routine/presentation/routine_labels.dart';
import 'package:timezone/timezone.dart' as tz;

/// Local notifications for routine tasks (KFS4). They are scheduled on the
/// phone, so they also come without internet.
final _plugin = FlutterLocalNotificationsPlugin();

final _taps = StreamController<void>.broadcast();

/// iOS keeps at most 64 pending notifications per app.
const _maxScheduled = 60;

const _details = NotificationDetails(
  android: AndroidNotificationDetails(
    'routine_reminders',
    'Przypomnienia o zadaniach',
    channelDescription: 'Leki, posiłki i nawodnienie.',
    importance: Importance.high,
    priority: Priority.high,
    category: AndroidNotificationCategory.reminder,
    icon: 'small_eldery_icon',
  ),
  iOS: DarwinNotificationDetails(),
);

Future<void> setUpRoutineReminders() async {
  await _plugin.initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('small_eldery_icon'),
      // Asked after login, see [requestRoutineReminderPermission].
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestSoundPermission: false,
        requestBadgePermission: false,
      ),
    ),
    onDidReceiveNotificationResponse: (_) => _taps.add(null),
  );
}

Future<void> requestRoutineReminderPermission() async {
  await _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.requestNotificationsPermission();
  await _plugin
      .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin
      >()
      ?.requestPermissions(alert: true, sound: true);
}

/// Taps on a reminder, including the one that launched the app.
Stream<void> routineReminderTaps() async* {
  final launch = await _plugin.getNotificationAppLaunchDetails();
  if (launch?.didNotificationLaunchApp ?? false) yield null;
  yield* _taps.stream;
}

/// Replaces the scheduled reminders with the ones for [occurrences].
Future<void> scheduleRoutineReminders(List<TaskOccurrence> occurrences) async {
  await cancelRoutineReminders();

  final now = DateTime.now();
  final reminders = [
    for (final occurrence in occurrences)
      if (occurrence.status == 'pending')
        for (final at in occurrence.reminderAt)
          if (at.isAfter(now)) (occurrence: occurrence, at: at),
  ]..sort((a, b) => a.at.compareTo(b.at));

  // Without the exact alarm permission Android may deliver a few minutes late.
  final canBeExact =
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.canScheduleExactNotifications() ??
      false;
  final mode = canBeExact
      ? AndroidScheduleMode.exactAllowWhileIdle
      : AndroidScheduleMode.inexactAllowWhileIdle;

  for (final (id, reminder) in reminders.take(_maxScheduled).indexed) {
    final occurrence = reminder.occurrence;
    final early = reminder.at.isBefore(occurrence.scheduledAt);
    await _plugin.zonedSchedule(
      id: id,
      scheduledDate: tz.TZDateTime.from(reminder.at.toUtc(), tz.UTC),
      notificationDetails: _details,
      androidScheduleMode: mode,
      title: early
          ? 'Za 15 minut: ${occurrence.title}'
          : 'Czas na: ${occurrence.title}',
      body:
          'Godzina ${formatClock(occurrence.scheduledAt)}. '
          '${occurrence.instructions}',
      payload: occurrence.occurrenceId,
    );
  }
}

/// Removes reminders that have not fired yet.
Future<void> cancelRoutineReminders() =>
    _plugin.cancelAllPendingNotifications();
