import 'package:flutter/material.dart';
import 'package:mobile_zpi/widgets/app_app_bar.dart';

class BackScaffold extends StatelessWidget {
  const BackScaffold({super.key, required this.title, required this.body});

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: title),
      body: body,
    );
  }
}
