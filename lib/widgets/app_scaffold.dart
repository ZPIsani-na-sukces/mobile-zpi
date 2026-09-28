import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/widgets/app_bottom_nav.dart';

@RoutePage()
class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key});

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
        return Scaffold(body: child, bottomNavigationBar: const AppBottomNav());
      },
    );
  }
}
