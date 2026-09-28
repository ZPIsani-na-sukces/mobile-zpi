import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final tabsRouter = AutoTabsRouter.of(context, watch: true);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: tabsRouter.activeIndex,
      onTap: tabsRouter.setActiveIndex,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Routine'),
        BottomNavigationBarItem(icon: Icon(Icons.contacts), label: 'Contacts'),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Med history',
        ),
      ],
    );
  }
}
