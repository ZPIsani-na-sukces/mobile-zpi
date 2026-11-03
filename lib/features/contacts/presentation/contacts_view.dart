import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/contacts/controllers/contacts_controller.dart';
import 'package:mobile_zpi/features/contacts/data/models/contact.dart';
import 'package:mobile_zpi/features/home/data/phone_call.dart';
import 'package:mobile_zpi/features/profile/controllers/profile_controller.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';
import 'package:mobile_zpi/widgets/app_message.dart';

@RoutePage()
class ContactsView extends ConsumerWidget {
  const ContactsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);

    return switch (profile) {
      AsyncData(value: final account) => _ContactList(seniorId: account.userId),
      AsyncError() => AppMessage(
        text: 'Nie udało się wczytać profilu.',
        actionLabel: 'Spróbuj ponownie',
        onPressed: () => ref.invalidate(profileControllerProvider),
      ),
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
    };
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
      AsyncData(value: final items) when items.isEmpty => const AppMessage(
        text: 'Brak kontaktów.',
      ),
      AsyncData(value: final items) => RefreshIndicator(
        onRefresh: () => ref.refresh(provider.future),
        child: ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) => _ContactCard(contact: items[index]),
        ),
      ),
      AsyncError() => AppMessage(
        text: 'Nie udało się wczytać kontaktów.',
        actionLabel: 'Spróbuj ponownie',
        onPressed: () => ref.invalidate(provider),
      ),
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.contact});

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final relationship = contact.relationshipLabel;
    final fullName = [
      contact.firstName,
      contact.lastName,
    ].nonNulls.where((part) => part.isNotEmpty).join(' ');
    final creator = contact.createdBy;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: context.colors.cardBorder,
        borderRadius: AppRadius.lgAll,
        boxShadow: AppShadows.sm,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (relationship != null && relationship.isNotEmpty) ...[
              Text(
                relationship,
                style: AppTypography.labelLarge.copyWith(
                  color: context.colors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
            ],
            Text(
              contact.displayName,
              style: AppTypography.titleLarge.copyWith(
                color: context.colors.onBackground,
              ),
            ),
            if (fullName.isNotEmpty && fullName != contact.displayName) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                fullName,
                style: AppTypography.bodyLarge.copyWith(
                  color: context.colors.onSurface,
                ),
              ),
            ],
            if (creator != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Dodane przez: ${creator.firstName} ${creator.lastName}',
                style: AppTypography.bodyMedium.copyWith(
                  color: context.colors.onSurface,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            AppButton.primary(
              label: 'Zadzwoń',
              icon: Icons.call,
              onPressed: () async {
                try {
                  await callPhone(contact.phoneNumber);
                } on PhoneCallException {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nie udało się otworzyć telefonu.'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
