import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final tabsRouter = AutoTabsRouter.of(context, watch: true);
    final colors = context.colors;

    // In high contrast the bar is as white as the page, so it needs an edge.
    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        border: colors.isHighContrast
            ? Border(top: BorderSide(color: colors.outline, width: 2))
            : null,
      ),
      child: BottomNavigationBar(
        currentIndex: tabsRouter.activeIndex,
        onTap: tabsRouter.setActiveIndex,
        items: const [
          BottomNavigationBarItem(
            icon: _BottomNavIcon(Icons.home_outlined),
            activeIcon: _BottomNavIcon(Icons.home_rounded),
            label: 'Start',
          ),
          BottomNavigationBarItem(
            icon: _BottomNavIcon(Icons.event_note_outlined),
            activeIcon: _BottomNavIcon(Icons.event_note_rounded),
            label: 'Zadania',
          ),
          BottomNavigationBarItem(
            icon: _BottomNavIcon(Icons.contacts_outlined),
            activeIcon: _BottomNavIcon(Icons.contacts_rounded),
            label: 'Kontakty',
          ),
          BottomNavigationBarItem(
            icon: _BottomNavIcon(Icons.assignment_outlined),
            activeIcon: _BottomNavIcon(Icons.assignment_rounded),
            label: 'Dokumenty',
          ),
        ],
      ),
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
