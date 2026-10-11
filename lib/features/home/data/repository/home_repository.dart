import 'package:mobile_zpi/config/app_env.dart';
import 'package:mobile_zpi/features/home/data/models/home_overview.dart';
import 'package:mobile_zpi/features/home/data/repository/api_home_repository.dart';
import 'package:mobile_zpi/features/home/data/repository/mock_home_repository.dart';
import 'package:mobile_zpi/network/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repository.g.dart';

abstract interface class HomeRepository {
  Future<List<HomeContact>> recentContacts(String seniorId);

  Future<List<UpcomingTask>> upcomingTasks(String seniorId);

  Future<List<HomeZone>> geozones(String seniorId);
}

@Riverpod(keepAlive: true)
HomeRepository homeRepository(Ref ref) {
  if (AppEnv.useMocks) return MockHomeRepository();
  return ApiHomeRepository(ref.watch(authDioProvider));
}
