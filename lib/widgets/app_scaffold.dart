import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/widgets/app_app_bar.dart';
import 'package:mobile_zpi/widgets/app_bottom_nav.dart';

@RoutePage()
class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key});

  static const List<String> _tabTitles = [
    'Start',
    'Zadania',
    'Kontakty',
    'Dokumenty',
  ];

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        RoutineRoute(),
        ContactsRoute(),
        MedHistoryRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        return Scaffold(
          appBar: AppAppBar(
            title: _tabTitles[tabsRouter.activeIndex],
            actions: [
              IconButton(
                tooltip: 'Profil',
                onPressed: () => context.router.push(const ProfileRoute()),
                icon: const Icon(Icons.account_circle_outlined, size: 32),
              ),
            ],
          ),
          body: child,
          bottomNavigationBar: const AppBottomNav(),
        );
      },
    );
  }
}
