import 'package:mobile_zpi/features/routine/data/models/routine_task.dart';
import 'package:mobile_zpi/features/routine/data/repository/routine_repository.dart';
import 'package:mobile_zpi/features/routine/data/routine_task_draft.dart';

class MockRoutineRepository implements RoutineRepository {
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

  static String _date(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }
}
