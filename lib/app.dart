import 'package:flutter/material.dart';
import 'package:mobile_zpi/router/app_router.dart';
import 'package:mobile_zpi/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.light,
      routerConfig: _appRouter.config(),
    );
  }
}
