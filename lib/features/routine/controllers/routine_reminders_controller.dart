import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/auth/shared/controllers/auth_controller.dart';
import 'package:mobile_zpi/features/routine/data/repository/routine_repository.dart';
import 'package:mobile_zpi/features/routine/data/routine_reminders.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routine_reminders_controller.g.dart';

/// Keeps the local reminders in line with the senior's pending tasks.
/// Invalidate it to fetch the tasks again.
@Riverpod(keepAlive: true)
class RoutineRemindersController extends _$RoutineRemindersController {
  String? _askedPermissionFor;

  @override
  Future<void> build() async {
    final seniorId = ref.watch(
      authControllerProvider.select((auth) => auth.value?.user.userId),
    );
    if (seniorId == null) {
      _askedPermissionFor = null;
      await cancelRoutineReminders();
      return;
    }

    if (_askedPermissionFor != seniorId) {
      _askedPermissionFor = seniorId;
      await requestRoutineReminderPermission();
    }
    final occurrences = await ref
        .watch(routineRepositoryProvider)
        .upcomingOccurrences(seniorId);
    await scheduleRoutineReminders(occurrences);
  }
}

/// Taps on a reminder. Each tap is a new object, so listeners hear every one.
@Riverpod(keepAlive: true)
Stream<Object> routineReminderTap(Ref ref) =>
    routineReminderTaps().map((_) => Object());
