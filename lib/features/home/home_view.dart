import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile_zpi/config/app_env.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Home page'),
          ElevatedButton(
            onPressed: () => context.router.push(const SosRoute()),
            child: const Text('SOS'),
          ),
          if (AppEnv.isDev)
            ElevatedButton(
              onPressed: () => context.router.push(const PlaygroudRoute()),
              child: const Text('Playground'),
            ),
        ],
      ),
    );
  }
}
