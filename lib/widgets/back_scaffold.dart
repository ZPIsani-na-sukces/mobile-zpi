import 'package:flutter/material.dart';

class BackScaffold extends StatelessWidget {
  const BackScaffold({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: body);
  }
}
