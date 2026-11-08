import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/auth/shared/controllers/auth_controller.dart';
import 'package:mobile_zpi/features/profile/controllers/accessibility_controller.dart';
import 'package:mobile_zpi/features/routine/controllers/routine_reminders_controller.dart';
import 'package:mobile_zpi/router/app_router.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/theme/app_theme.dart';

class MyApp extends ConsumerWidget {
  MyApp({super.key, required ProviderContainer container})
    : _appRouter = AppRouter(
        isSignedIn: () => container.read(authControllerProvider).value != null,
      );

  final AppRouter _appRouter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authControllerProvider.select((auth) => auth.value != null), (
      wasSignedIn,
      isSignedIn,
    ) {
      if (wasSignedIn == true && !isSignedIn) {
        _appRouter.replaceAll([const LoginRoute()]);
      }
    });

    ref.listen(routineReminderTapProvider, (_, next) async {
      if (next is! AsyncData ||
          ref.read(authControllerProvider).value == null) {
        return;
      }
      // On a cold start the tap can come before the router shows a page.
      await WidgetsBinding.instance.endOfFrame;
      await _appRouter.navigate(const AppRoute(children: [RoutineRoute()]));
    });

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
