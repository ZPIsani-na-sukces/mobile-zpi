import 'package:auto_route/auto_route.dart';
import 'package:mobile_zpi/config/app_env.dart';
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
    AutoRoute(path: '/profile', page: ProfileRoute.page),
    AutoRoute(path: '/profile/edit', page: ProfileEditRoute.page),
    AutoRoute(path: '/routine/new', page: CreateRoutineTaskRoute.page),
    AutoRoute(path: '/routine/task', page: RoutineTaskRoute.page),
    AutoRoute(path: '/sos', page: SosRoute.page),
    AutoRoute(path: '/login', page: LoginRoute.page),
    AutoRoute(path: '/register', page: RegisterRoute.page),
    AutoRoute(path: '/reset-password', page: ResetPassRoute.page),
    AutoRoute(path: '/verify-account', page: AccActivationRoute.page),
    if (AppEnv.isDev) AutoRoute(path: '/playground', page: PlaygroudRoute.page),
  ];
}
