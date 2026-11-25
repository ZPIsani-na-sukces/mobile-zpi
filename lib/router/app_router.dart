import 'package:auto_route/auto_route.dart';
import 'package:mobile_zpi/config/app_env.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Screen|View|Scaffold,Route')
class AppRouter extends RootStackRouter {
  AppRouter({required this._isSignedIn});

  final bool Function() _isSignedIn;

  // Mocks show Home without a session, so they skip this.
  late final _signedInGuard = AutoRouteGuard.redirect(
    (_) => _isSignedIn() || AppEnv.useMocks ? null : const LoginRoute(),
  );

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      path: '/',
      page: AppRoute.page,
      initial: true,
      guards: [_signedInGuard],
      children: [
        AutoRoute(path: 'home', page: HomeRoute.page, initial: true),
        AutoRoute(path: 'routine', page: RoutineRoute.page),
        AutoRoute(path: 'med-history', page: MedHistoryRoute.page),
        AutoRoute(path: 'profile', page: ProfileRoute.page),
      ],
    ),
    AutoRoute(path: '/geozones', page: GeozoneRoute.page),
    AutoRoute(path: '/profile/edit', page: ProfileEditRoute.page),
    AutoRoute(path: '/profile/edit/contact', page: ContactChangeRoute.page),
    AutoRoute(path: '/routine/new', page: CreateRoutineTaskRoute.page),
    AutoRoute(path: '/routine/task', page: RoutineTaskRoute.page),
    AutoRoute(path: '/med-history/file', page: MedFileRoute.page),
    AutoRoute(
      path: '/med-history/file/preview',
      page: MedFilePreviewRoute.page,
    ),
    AutoRoute(path: '/contacts', page: ContactsRoute.page),
    AutoRoute(path: '/contacts/details', page: ContactDetailsRoute.page),
    AutoRoute(path: '/sos', page: SosRoute.page),
    AutoRoute(path: '/caretakers', page: CaretakersRoute.page),
    AutoRoute(path: '/invitations/add', page: AddCaretakerRoute.page),
    AutoRoute(path: '/invitations/accept', page: AcceptInvitationRoute.page),
    AutoRoute(path: '/invitations/send', page: SendInvitationRoute.page),
    AutoRoute(path: '/invitations/scan', page: ScanInvitationRoute.page),
    AutoRoute(path: '/login', page: LoginRoute.page),
    AutoRoute(path: '/register', page: RegisterRoute.page),
    AutoRoute(path: '/reset-password', page: ResetPassRoute.page),
    AutoRoute(path: '/verify-account', page: AccActivationRoute.page),
    if (AppEnv.isDev) AutoRoute(path: '/playground', page: PlaygroudRoute.page),
  ];
}
