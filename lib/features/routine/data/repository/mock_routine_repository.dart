import 'package:mobile_zpi/features/routine/data/models/routine_task.dart';
import 'package:mobile_zpi/features/routine/data/models/task_occurrence.dart';
import 'package:mobile_zpi/features/routine/data/repository/routine_repository.dart';
import 'package:mobile_zpi/features/routine/data/routine_task_draft.dart';

class MockRoutineRepository implements RoutineRepository {
  final _occurrences = <TaskOccurrence>[
    TaskOccurrence(
      occurrenceId: 'occ-1',
      taskId: '1',
      title: 'Lek poranny',
      instructions: 'Przyjmij jedną tabletkę po śniadaniu.',
      type: 'medication',
      scheduledAt: DateTime.now().copyWith(hour: 8, minute: 0),
      status: 'pending',
    ),
    TaskOccurrence(
      occurrenceId: 'occ-2',
      taskId: '2',
      title: 'Śniadanie',
      instructions: 'Zjedz śniadanie.',
      type: 'meal',
      scheduledAt: DateTime.now().copyWith(hour: 8, minute: 30),
      status: 'pending',
    ),
    TaskOccurrence(
      occurrenceId: 'occ-3',
      taskId: '3',
      title: 'Szklanka wody',
      instructions: 'Wypij szklankę wody.',
      type: 'hydration',
      scheduledAt: DateTime.now().copyWith(hour: 11, minute: 0),
      status: 'pending',
    ),
    TaskOccurrence(
      occurrenceId: 'occ-4',
      taskId: '3',
      title: 'Szklanka wody',
      instructions: 'Wypij szklankę wody.',
      type: 'hydration',
      scheduledAt: DateTime.now().copyWith(hour: 15, minute: 0),
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
  Future<List<TaskOccurrence>> occurrencesToday(String seniorId) async {
    return List<TaskOccurrence>.of(_occurrences);
  }

  @override
  Future<List<TaskOccurrence>> upcomingOccurrences(
    String seniorId, {
    int days = 7,
  }) async {
    return [
      for (final occurrence in _occurrences)
        if (occurrence.status == 'pending')
          occurrence.copyWith(
            reminderAt: [
              occurrence.scheduledAt.subtract(const Duration(minutes: 15)),
              occurrence.scheduledAt,
            ],
          ),
    ];
  }

  @override
  Future<void> decide(
    String seniorId,
    String occurrenceId,
    String decision,
  ) async {
    final index = _occurrences.indexWhere(
      (item) => item.occurrenceId == occurrenceId,
    );
    if (index == -1) return;
    _occurrences[index] = _occurrences[index].copyWith(status: decision);
  }

  static String _date(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }
}
