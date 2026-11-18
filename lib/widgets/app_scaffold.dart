import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile_zpi/features/home_widgets/presentation/home_widget_launch_listener.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/widgets/app_app_bar.dart';
import 'package:mobile_zpi/widgets/app_bottom_nav.dart';

@RoutePage()
class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key});

  static const List<String> _tabTitles = [
    'Start',
    'Zadania',
    'Zdrowie',
    'Profil',
  ];

  @override
  Widget build(BuildContext context) {
    return HomeWidgetLaunchListener(
      child: AutoTabsRouter(
        routes: const [
          HomeRoute(),
          RoutineRoute(),
          MedHistoryRoute(),
          ProfileRoute(),
        ],
        builder: (context, child) {
          final tabsRouter = AutoTabsRouter.of(context);

          return Scaffold(
            appBar: AppAppBar(
              title: _tabTitles[tabsRouter.activeIndex],
              centerTitle: true,
            ),
            body: child,
            bottomNavigationBar: const AppBottomNav(),
          );
        },
      ),
    );
  }
}
