import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/contacts/presentation/widgets/contact_tile.dart';
import 'package:mobile_zpi/features/home/controllers/home_controller.dart';
import 'package:mobile_zpi/features/home/presentation/widgets/back_home_card.dart';
import 'package:mobile_zpi/features/home/presentation/widgets/home_greeting.dart';
import 'package:mobile_zpi/features/home/presentation/widgets/home_section.dart';
import 'package:mobile_zpi/features/home/presentation/widgets/home_zone_tile.dart';
import 'package:mobile_zpi/features/home/presentation/widgets/upcoming_task_tile.dart';
import 'package:mobile_zpi/features/profile/controllers/profile_controller.dart';
import 'package:mobile_zpi/features/sos/presentation/sos_button.dart';
import 'package:mobile_zpi/keys.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/widgets/app_button.dart';
import 'package:mobile_zpi/widgets/app_empty_card.dart';
import 'package:mobile_zpi/widgets/app_no_connection_info.dart';

@RoutePage()
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);

    return switch (profile) {
      AsyncData(value: final account) => _HomeBody(
        firstName: account.firstName,
        seniorId: account.userId,
      ),
      AsyncError() => AppNoConnectionInfo(
        onRetry: () => ref.invalidate(profileControllerProvider),
      ),
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _HomeBody extends ConsumerWidget {
  const _HomeBody({required this.firstName, required this.seniorId});

  final String firstName;
  final String seniorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeControllerProvider(seniorId));

    void openMap() => context.router.push(GeozoneRoute(seniorId: seniorId));

    return switch (home) {
      AsyncData(value: final overview) => ListView(
        key: keys.home.page,
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          HomeGreeting(firstName: firstName),
          const SizedBox(height: AppSpacing.xl),
          Center(
            child: SosButton(
              key: keys.home.sosButton,
              onPressed: () =>
                  context.router.push(SosRoute(seniorId: seniorId)),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          BackHomeCard(seniorId: seniorId),
          const SizedBox(height: AppSpacing.xxl),
          HomeSection(
            title: 'Kontakty',
            actionKey: keys.home.allContactsButton,
            actionLabel: overview.contacts.isEmpty ? null : 'Wszystkie',
            onAction: () => context.router.push(const ContactsRoute()),
            child: overview.contacts.isEmpty
                ? const AppEmptyCard(
                    icon: Icons.contact_phone_outlined,
                    title: 'Brak kontaktów',
                    description: 'Poproś opiekuna o dodanie bliskich osób.',
                  )
                : Column(
                    spacing: AppSpacing.sm,
                    children: [
                      for (final contact in overview.contacts)
                        ContactTile(
                          key: keys.home.contactTile(contact.contactId),
                          name: contact.displayName,
                          relationship: contact.relationshipLabel,
                          phoneNumber: contact.phoneNumber,
                          onTap: () => context.router.push(
                            ContactDetailsRoute(
                              seniorId: seniorId,
                              contactId: contact.contactId,
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
          const SizedBox(height: AppSpacing.xl),
          HomeSection(
            title: 'Nadchodzące zadania',
            child: overview.tasks.isEmpty
                ? const AppEmptyCard(
                    icon: Icons.event_available_outlined,
                    title: 'Na dziś nic nie zaplanowano',
                    description: 'Zadania od opiekuna pojawią się tutaj.',
                  )
                : Column(
                    spacing: AppSpacing.sm,
                    children: [
                      for (final task in overview.tasks)
                        UpcomingTaskTile(
                          key: keys.home.taskTile(task.occurrenceId),
                          task: task,
                          onTap: () async {
                            await context.router.push(
                              RoutineTaskRoute(
                                seniorId: seniorId,
                                taskId: task.taskId,
                              ),
                            );
                            if (!context.mounted) return;
                            ref.invalidate(homeControllerProvider(seniorId));
                          },
                        ),
                    ],
                  ),
          ),
          const SizedBox(height: AppSpacing.xl),
          HomeSection(
            title: 'Geostrefy',
            actionLabel: overview.zones.isEmpty ? null : 'Mapa',
            onAction: openMap,
            child: overview.zones.isEmpty
                ? AppEmptyCard(
                    icon: Icons.place_outlined,
                    title: 'Brak ustawionych geostref',
                    description: 'Poproś opiekuna o ich dodanie.',
                    action: AppButton.secondary(
                      label: 'Otwórz mapę',
                      icon: Icons.map_outlined,
                      onPressed: openMap,
                    ),
                  )
                : Column(
                    spacing: AppSpacing.sm,
                    children: [
                      for (final zone in overview.zones.take(3))
                        HomeZoneTile(
                          key: keys.home.zoneTile(zone.zoneId),
                          zone: zone,
                          onTap: () => context.router.push(
                            GeozoneRoute(
                              seniorId: seniorId,
                              initialZoneId: zone.zoneId,
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
      AsyncError() => AppNoConnectionInfo(
        onRetry: () => ref.invalidate(homeControllerProvider(seniorId)),
      ),
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
    };
  }
}
