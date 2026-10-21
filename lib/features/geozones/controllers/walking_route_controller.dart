import 'package:latlong2/latlong.dart';
import 'package:mobile_zpi/features/geozones/data/models/walking_route.dart';
import 'package:mobile_zpi/features/geozones/data/repository/geozones_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'walking_route_controller.g.dart';

@riverpod
class WalkingRouteController extends _$WalkingRouteController {
  @override
  FutureOr<WalkingRoute?> build() => null;

  Future<void> fetch(LatLng destination) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(geozonesRepositoryProvider).getWalkingRoute(destination),
    );
  }
}
