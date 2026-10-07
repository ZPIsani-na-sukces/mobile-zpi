import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile_zpi/widgets/back_scaffold.dart';

@RoutePage()
class SosView extends StatelessWidget {
  const SosView({super.key});

  @override
  Widget build(BuildContext context) {
    return const BackScaffold(body: Center(child: Text('Sos view')));
  }
}
