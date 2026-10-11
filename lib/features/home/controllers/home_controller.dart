import 'package:mobile_zpi/features/home/data/models/home_overview.dart';
import 'package:mobile_zpi/features/home/data/repository/home_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_controller.g.dart';

@riverpod
class HomeController extends _$HomeController {
  @override
  Future<HomeOverview> build(String seniorId) async {
    final repository = ref.watch(homeRepositoryProvider);
    final contactsFuture = repository.recentContacts(seniorId);
    final tasksFuture = repository.upcomingTasks(seniorId);
    final zonesFuture = repository.geozones(seniorId);
    return HomeOverview(
      contacts: await contactsFuture,
      tasks: await tasksFuture,
      zones: await zonesFuture,
    );
  }
}
