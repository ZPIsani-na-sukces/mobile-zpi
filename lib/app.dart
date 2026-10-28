import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/profile/controllers/accessibility_controller.dart';
import 'package:mobile_zpi/router/app_router.dart';
import 'package:mobile_zpi/theme/app_theme.dart';

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final highContrast =
        ref.watch(highContrastControllerProvider).value ?? false;

    return MaterialApp.router(
      theme: AppTheme.standard,
      // The app has no dark mode, so the dark slot holds high contrast.
      darkTheme: AppTheme.highContrast,
      themeMode: highContrast ? ThemeMode.dark : ThemeMode.light,
      routerConfig: _appRouter.config(),
    );
  }
}
