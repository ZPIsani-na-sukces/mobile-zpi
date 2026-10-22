import 'package:mobile_zpi/features/geozones/controllers/walking_route_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'route_navigation_controller.g.dart';

@riverpod
class RouteNavigationController extends _$RouteNavigationController {
  @override
  bool build() {
    ref.watch(walkingRouteControllerProvider);
    return false;
  }

  void start() => state = true;
}
