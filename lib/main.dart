import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/app.dart';
import 'package:mobile_zpi/features/auth/shared/controllers/auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  await container.read(authControllerProvider.future);

  runApp(UncontrolledProviderScope(container: container, child: MyApp()));
}
