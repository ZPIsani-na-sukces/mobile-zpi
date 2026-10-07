import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/contacts/controllers/contacts_controller.dart';
import 'package:mobile_zpi/features/contacts/data/models/contact.dart';

// TODO: replace with the logged-in senior's id once a session provider exists.
const _seniorId = 'senior-1';

@RoutePage()
class ContactsView extends HookConsumerWidget {
  const ContactsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasAddedContact = useRef(false);

    ref.listen(contactsControllerProvider(_seniorId), (_, next) {
      if (next case AsyncData(:final value)) {
        debugPrint('Contacts loaded: ${value.length}');

        // Debug: add one contact after the first fetch.
        if (!hasAddedContact.value) {
          hasAddedContact.value = true;
          final now = DateTime.now();
          ref
              .read(contactsControllerProvider(_seniorId).notifier)
              .addContact(
                Contact(
                  contactId: now.millisecondsSinceEpoch.toString(),
                  seniorId: _seniorId,
                  displayName: 'Test contact',
                  firstName: 'Test',
                  lastName: 'Contact',
                  phoneNumber: '+48 500 000 000',
                  isActive: true,
                  createdBy: const ContactCreator(
                    userId: 'caregiver-1',
                    firstName: 'Katarzyna',
                    lastName: 'Wiśniewska',
                    role: 'CAREGIVER',
                  ),
                  createdAt: now,
                  updatedAt: now,
                  version: 1,
                ),
              );
        }
      }
    });

    return const Center(child: Text('Contacts page'));
  }
}
