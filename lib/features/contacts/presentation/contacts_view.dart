import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/contacts/controllers/contacts_controller.dart';
import 'package:mobile_zpi/features/contacts/presentation/widgets/contact_tile.dart';
import 'package:mobile_zpi/features/profile/controllers/profile_controller.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/widgets/app_empty_card.dart';
import 'package:mobile_zpi/widgets/app_no_connection_info.dart';
import 'package:mobile_zpi/widgets/back_scaffold.dart';

@RoutePage()
class ContactsView extends ConsumerWidget {
  const ContactsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);

    return BackScaffold(
      title: 'Kontakty',
      body: switch (profile) {
        AsyncData(value: final account) => _ContactList(
          seniorId: account.userId,
        ),
        AsyncError() => AppNoConnectionInfo(
          onRetry: () => ref.invalidate(profileControllerProvider),
        ),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _ContactList extends ConsumerWidget {
  const _ContactList({required this.seniorId});

  final String seniorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = contactsControllerProvider(seniorId);
    final contacts = ref.watch(provider);

    return switch (contacts) {
      AsyncData(value: final items) => RefreshIndicator(
        onRefresh: () => ref.refresh(provider.future),
        child: items.isEmpty
            ? ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: const [
                  AppEmptyCard(
                    icon: Icons.contact_phone_outlined,
                    title: 'Brak kontaktów',
                    description: 'Poproś opiekuna o dodanie bliskich osób.',
                  ),
                ],
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: items.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final contact = items[index];
                  return ContactTile(
                    name: contact.displayName,
                    relationship: contact.relationshipLabel,
                    phoneNumber: contact.phoneNumber,
                    onTap: () => context.router.push(
                      ContactDetailsRoute(
                        seniorId: seniorId,
                        contactId: contact.contactId,
                      ),
                    ),
                  );
                },
              ),
      ),
      AsyncError() => AppNoConnectionInfo(
        onRetry: () => ref.invalidate(provider),
      ),
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
    };
  }
}
