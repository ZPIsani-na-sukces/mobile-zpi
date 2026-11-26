import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/contacts/controllers/contacts_controller.dart';
import 'package:mobile_zpi/features/contacts/presentation/widgets/call_button.dart';
import 'package:mobile_zpi/keys.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_detail_row.dart';
import 'package:mobile_zpi/widgets/app_details_card.dart';
import 'package:mobile_zpi/widgets/app_initials_avatar.dart';
import 'package:mobile_zpi/widgets/app_message.dart';
import 'package:mobile_zpi/widgets/app_no_connection_info.dart';
import 'package:mobile_zpi/widgets/back_scaffold.dart';

@RoutePage()
class ContactDetailsView extends ConsumerWidget {
  const ContactDetailsView({
    super.key,
    required this.seniorId,
    required this.contactId,
  });

  final String seniorId;
  final String contactId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = contactsControllerProvider(seniorId);
    final contacts = ref.watch(provider);
    final colors = context.colors;

    return BackScaffold(
      key: keys.contactDetails.page,
      title: 'Kontakt',
      body: switch (contacts) {
        AsyncData(value: final items) => switch (items
            .where((contact) => contact.contactId == contactId)
            .firstOrNull) {
          null => const AppMessage(text: 'Nie znaleziono kontaktu.'),
          final contact => Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    Center(
                      child: AppInitialsAvatar.large(name: contact.displayName),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (contact.relationshipLabel case final relationship?
                        when relationship.isNotEmpty) ...[
                      Text(
                        relationship,
                        textAlign: TextAlign.center,
                        style: AppTypography.titleMedium.copyWith(
                          color: colors.primary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                    ],
                    Text(
                      contact.displayName,
                      textAlign: TextAlign.center,
                      style: AppTypography.headlineLarge.copyWith(
                        color: colors.onBackground,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppDetailsCard(
                      rows: [
                        if (contact.fullName.isNotEmpty)
                          AppDetailRow(
                            icon: Icons.badge_outlined,
                            label: 'Imię i nazwisko',
                            value: contact.fullName,
                          ),
                        AppDetailRow(
                          icon: Icons.phone_outlined,
                          label: 'Numer telefonu',
                          value: contact.phoneNumber,
                        ),
                        if (contact.createdBy case final creator?)
                          AppDetailRow(
                            icon: Icons.person_outline,
                            label: 'Dodane przez',
                            value: '${creator.firstName} ${creator.lastName}',
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                minimum: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: CallButton(
                  phoneNumber: contact.phoneNumber,
                  name: contact.displayName,
                ),
              ),
            ],
          ),
        },
        AsyncError() => AppNoConnectionInfo(
          onRetry: () => ref.invalidate(provider),
        ),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
