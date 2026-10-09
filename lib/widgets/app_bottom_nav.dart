import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final tabsRouter = AutoTabsRouter.of(context, watch: true);

    return BottomNavigationBar(
      currentIndex: tabsRouter.activeIndex,
      onTap: tabsRouter.setActiveIndex,
      items: const [
        BottomNavigationBarItem(
          icon: _BottomNavIcon(Icons.home_outlined),
          activeIcon: _BottomNavIcon(Icons.home_rounded),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: _BottomNavIcon(Icons.event_note_outlined),
          activeIcon: _BottomNavIcon(Icons.event_note_rounded),
          label: 'Routines',
        ),
        BottomNavigationBarItem(
          icon: _BottomNavIcon(Icons.contacts_outlined),
          activeIcon: _BottomNavIcon(Icons.contacts_rounded),
          label: 'Contacts',
        ),
        BottomNavigationBarItem(
          icon: _BottomNavIcon(Icons.assignment_outlined),
          activeIcon: _BottomNavIcon(Icons.assignment_rounded),
          label: 'Med history',
        ),
      ],
    );
  }
}

class _BottomNavIcon extends StatelessWidget {
  const _BottomNavIcon(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.sm),
      child: Icon(icon),
    );
  }
}
