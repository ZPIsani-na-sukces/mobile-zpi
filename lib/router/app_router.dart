import 'package:auto_route/auto_route.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Screen|View|Scaffold,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      path: '/',
      page: AppRoute.page,
      initial: true,
      children: [
        AutoRoute(path: 'home', page: HomeRoute.page, initial: true),
        AutoRoute(path: 'routine', page: RoutineRoute.page),
        AutoRoute(path: 'contacts', page: ContactsRoute.page),
        AutoRoute(path: 'med-history', page: MedHistoryRoute.page),
      ],
    ),
    AutoRoute(path: '/sos', page: SosRoute.page),
  ];
}
