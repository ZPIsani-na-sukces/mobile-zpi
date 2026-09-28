import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ContactsView extends StatelessWidget {
  const ContactsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Contacts page'));
  }
}
