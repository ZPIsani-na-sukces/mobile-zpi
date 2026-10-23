import 'package:mobile_zpi/features/geozones/controllers/route_navigation_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_follow_controller.g.dart';

@riverpod
class MapFollowController extends _$MapFollowController {
  @override
  bool build() => ref.watch(routeNavigationControllerProvider);

  void follow() {
    if (ref.read(routeNavigationControllerProvider)) state = true;
  }

  void pause() => state = false;
}
