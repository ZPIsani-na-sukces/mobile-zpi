import 'package:mobile_zpi/features/routine/data/models/routine_task.dart';
import 'package:mobile_zpi/features/routine/data/models/task_occurrence.dart';
import 'package:mobile_zpi/features/routine/data/repository/routine_repository.dart';
import 'package:mobile_zpi/features/routine/data/routine_task_draft.dart';

class MockRoutineRepository implements RoutineRepository {
  final _pending = <TaskOccurrence>[
    TaskOccurrence(
      occurrenceId: '1',
      title: 'Lek poranny',
      instructions: 'Przyjmij jedną tabletkę po śniadaniu.',
      type: 'medication',
      scheduledAt: DateTime.now().copyWith(hour: 8, minute: 0),
      status: 'pending',
    ),
    TaskOccurrence(
      occurrenceId: '2',
      title: 'Szklanka wody',
      instructions: 'Wypij szklankę wody.',
      type: 'hydration',
      scheduledAt: DateTime.now().copyWith(hour: 11, minute: 0),
      status: 'pending',
    ),
  ];

  final _tasks = <RoutineTask>[
    const RoutineTask(
      taskId: '1',
      title: 'Lek poranny',
      type: 'medication',
      instructions: 'Przyjmij jedną tabletkę po śniadaniu.',
      isActive: true,
      startsOn: '2026-09-01',
      schedule: RoutineSchedule(
        timeZone: 'Europe/Warsaw',
        daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
        times: ['08:00:00'],
      ),
    ),
    const RoutineTask(
      taskId: '2',
      title: 'Śniadanie',
      type: 'meal',
      instructions: 'Zjedz śniadanie.',
      isActive: true,
      startsOn: '2026-09-01',
      schedule: RoutineSchedule(
        timeZone: 'Europe/Warsaw',
        daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
        times: ['08:30:00'],
      ),
    ),
    const RoutineTask(
      taskId: '3',
      title: 'Szklanka wody',
      type: 'hydration',
      instructions: 'Wypij szklankę wody.',
      isActive: true,
      startsOn: '2026-09-01',
      schedule: RoutineSchedule(
        timeZone: 'Europe/Warsaw',
        daysOfWeek: [1, 2, 3, 4, 5],
        times: ['11:00:00', '15:00:00'],
      ),
    ),
  ];

  @override
  Future<void> createTask(String seniorId, RoutineTaskDraft draft) async {
    _tasks.insert(
      0,
      RoutineTask(
        taskId: DateTime.now().microsecondsSinceEpoch.toString(),
        title: draft.title,
        type: draft.type,
        instructions: draft.instructions,
        isActive: true,
        startsOn: _date(draft.startsOn),
        endsOn: draft.endsOn == null ? null : _date(draft.endsOn!),
        schedule: RoutineSchedule(
          timeZone: 'Europe/Warsaw',
          daysOfWeek: draft.daysOfWeek,
          times: draft.times,
        ),
      ),
    );
  }

  @override
  Future<List<RoutineTask>> tasks(String seniorId) async =>
      List<RoutineTask>.of(_tasks);

  @override
  Future<RoutineTask> task(String seniorId, String taskId) async {
    return _tasks.firstWhere((task) => task.taskId == taskId);
  }

  @override
  Future<List<TaskOccurrence>> pendingToday(String seniorId) async {
    return List<TaskOccurrence>.of(_pending);
  }

  @override
  Future<void> decide(
    String seniorId,
    String occurrenceId,
    String decision,
  ) async {
    _pending.removeWhere((item) => item.occurrenceId == occurrenceId);
  }

  static String _date(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }
}
