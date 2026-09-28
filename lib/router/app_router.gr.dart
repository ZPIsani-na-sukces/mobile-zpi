// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:auto_route/auto_route.dart' as _i7;
import 'package:mobile_zpi/features/contacts/contacts_view.dart' as _i2;
import 'package:mobile_zpi/features/home/home_view.dart' as _i3;
import 'package:mobile_zpi/features/med_history/med_history_view.dart' as _i4;
import 'package:mobile_zpi/features/routine/routine_view.dart' as _i5;
import 'package:mobile_zpi/features/sos/sos_view.dart' as _i6;
import 'package:mobile_zpi/widgets/app_scaffold.dart' as _i1;

/// generated route for
/// [_i1.AppScaffold]
class AppRoute extends _i7.PageRouteInfo<void> {
  const AppRoute({List<_i7.PageRouteInfo>? children})
    : super(AppRoute.name, initialChildren: children);

  static const String name = 'AppRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i1.AppScaffold();
    },
  );
}

/// generated route for
/// [_i2.ContactsView]
class ContactsRoute extends _i7.PageRouteInfo<void> {
  const ContactsRoute({List<_i7.PageRouteInfo>? children})
    : super(ContactsRoute.name, initialChildren: children);

  static const String name = 'ContactsRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i2.ContactsView();
    },
  );
}

/// generated route for
/// [_i3.HomePage]
class HomeRoute extends _i7.PageRouteInfo<void> {
  const HomeRoute({List<_i7.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i3.HomePage();
    },
  );
}

/// generated route for
/// [_i4.MedHistoryView]
class MedHistoryRoute extends _i7.PageRouteInfo<void> {
  const MedHistoryRoute({List<_i7.PageRouteInfo>? children})
    : super(MedHistoryRoute.name, initialChildren: children);

  static const String name = 'MedHistoryRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i4.MedHistoryView();
    },
  );
}

/// generated route for
/// [_i5.RoutineView]
class RoutineRoute extends _i7.PageRouteInfo<void> {
  const RoutineRoute({List<_i7.PageRouteInfo>? children})
    : super(RoutineRoute.name, initialChildren: children);

  static const String name = 'RoutineRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i5.RoutineView();
    },
  );
}

/// generated route for
/// [_i6.SosView]
class SosRoute extends _i7.PageRouteInfo<void> {
  const SosRoute({List<_i7.PageRouteInfo>? children})
    : super(SosRoute.name, initialChildren: children);

  static const String name = 'SosRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i6.SosView();
    },
  );
}
