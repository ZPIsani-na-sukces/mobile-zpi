import 'package:mobile_zpi/features/home/data/models/home_overview.dart';
import 'package:mobile_zpi/features/home/data/repository/home_repository.dart';

class MockHomeRepository implements HomeRepository {
  @override
  Future<List<HomeContact>> recentContacts(String seniorId) async {
    return const [
      HomeContact(
        contactId: '1',
        displayName: 'Anna',
        relationshipLabel: 'Córka',
        phoneNumber: '+48600100200',
      ),
      HomeContact(
        contactId: '2',
        displayName: 'Jan',
        relationshipLabel: 'Syn',
        phoneNumber: '+48600300400',
      ),
      HomeContact(
        contactId: '3',
        displayName: 'Dr Zielińska',
        relationshipLabel: 'Lekarz rodzinny',
        phoneNumber: '+48225551234',
      ),
      HomeContact(
        contactId: '4',
        displayName: 'Maria',
        relationshipLabel: 'Sąsiadka',
        phoneNumber: '+48600500600',
      ),
    ];
  }

  @override
  Future<List<UpcomingTask>> upcomingTasks(String seniorId) async {
    final now = DateTime.now();
    return [
      UpcomingTask(
        occurrenceId: '1',
        taskId: '1',
        title: 'Leki poranne',
        scheduledAt: DateTime(now.year, now.month, now.day, 8),
        status: 'pending',
      ),
      UpcomingTask(
        occurrenceId: '2',
        taskId: '2',
        title: 'Śniadanie',
        scheduledAt: DateTime(now.year, now.month, now.day, 8, 30),
        status: 'pending',
      ),
      UpcomingTask(
        occurrenceId: '3',
        taskId: '3',
        title: 'Szklanka wody',
        scheduledAt: DateTime(now.year, now.month, now.day, 11),
        status: 'pending',
      ),
      UpcomingTask(
        occurrenceId: '4',
        taskId: '4',
        title: 'Leki wieczorne',
        scheduledAt: DateTime(now.year, now.month, now.day, 0, 5).add(const Duration(days: 1)),
        status: 'pending',
      ),
      UpcomingTask(
        occurrenceId: '5',
        taskId: '5',
        title: 'Szklanka wody',
        scheduledAt: DateTime(now.year, now.month, now.day, 0, 7).add(const Duration(days: 1)),
        status: 'pending',
      ),
    ];
  }

  @override
  Future<List<HomeZone>> geozones(String seniorId) async {
    return const [
      HomeZone(zoneId: '1', name: 'Dom', radiusMeters: 150),
      HomeZone(zoneId: '2', name: 'Ogródek', radiusMeters: 80),
    ];
  }
}
