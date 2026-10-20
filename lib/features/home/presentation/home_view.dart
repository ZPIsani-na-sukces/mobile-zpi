import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/home/controllers/home_controller.dart';
import 'package:mobile_zpi/features/home/data/back_home.dart';
import 'package:mobile_zpi/features/home/data/models/home_overview.dart';
import 'package:mobile_zpi/features/home/data/phone_call.dart';
import 'package:mobile_zpi/features/profile/controllers/home_address_controller.dart';
import 'package:mobile_zpi/features/profile/controllers/profile_controller.dart';
import 'package:mobile_zpi/features/profile/data/models/home_address.dart';
import 'package:mobile_zpi/features/sos/presentation/sos_button.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';

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
      AsyncError() => const _StatusMessage(
        text: 'Nie udało się wczytać ekranu głównego.',
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

    return switch (home) {
      AsyncData(value: final overview) => ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            'Dzień dobry, $firstName',
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.onBackground,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Center(
            child: SosButton(
              onPressed: () =>
                  context.router.push(SosRoute(seniorId: seniorId)),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _BackHomeButton(seniorId: seniorId),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: 'Ostatnie kontakty',
            child: overview.contacts.isEmpty
                ? const _EmptyText('Brak kontaktów.')
                : Column(
                    children: [
                      for (final contact in overview.contacts) ...[
                        _ContactTile(contact: contact),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                      AppButton.text(
                        label: 'Wszystkie kontakty',
                        onPressed: () =>
                            AutoTabsRouter.of(context).setActiveIndex(2),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: 'Nadchodzące zadania',
            child: overview.tasks.isEmpty
                ? const _EmptyText('Brak zadań na dziś.')
                : Column(
                    children: [
                      for (final task in overview.tasks) ...[
                        _TaskTile(task: task),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                    ],
                  ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: 'Geostrefy',
            child: overview.zones.isEmpty
                ? const _EmptyText('Brak ustawionych geostref.')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final zone in overview.zones.take(3)) ...[
                        _ZoneTile(zone: zone),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                      AppButton.text(
                        label: 'Podgląd geostref',
                        onPressed: () => context.router.push(
                          GeozonePreviewRoute(seniorId: seniorId),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
      AsyncError() => _StatusMessage(
        text: 'Nie udało się wczytać danych.',
        actionLabel: 'Spróbuj ponownie',
        onPressed: () => ref.invalidate(homeControllerProvider(seniorId)),
      ),
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _BackHomeButton extends ConsumerWidget {
  const _BackHomeButton({required this.seniorId});

  final String seniorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = homeAddressControllerProvider(seniorId);
    final address = ref.watch(provider);

    return AppButton.primary(
      label: 'Wróć do domu',
      icon: Icons.home_rounded,
      onPressed: switch (address) {
        AsyncData(value: final home) => () => _navigate(context, home),
        AsyncError() => () {
          ref.invalidate(provider);
          _showMessage(context, 'Nie udało się wczytać adresu domu.');
        },
        AsyncLoading() => null,
      },
    );
  }

  Future<void> _navigate(BuildContext context, HomeAddress? home) async {
    if (home == null) {
      _showMessage(
        context,
        'Adres domu nie jest ustawiony. Poproś opiekuna o jego dodanie.',
      );
      return;
    }
    try {
      await navigateBackHome(home.coordinates);
    } on BackHomeException {
      if (!context.mounted) return;
      _showMessage(context, 'Nie udało się otworzyć mapy.');
    }
  }

  void _showMessage(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({required this.contact});

  final HomeContact contact;

  @override
  Widget build(BuildContext context) {
    final subtitle = contact.relationshipLabel;

    return _Card(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.displayName,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.onBackground,
                  ),
                ),
                if (subtitle != null && subtitle.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            tooltip: 'Zadzwoń',
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
            icon: const Icon(Icons.call, color: AppColors.primary, size: 28),
          ),
        ],
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({required this.task});

  final UpcomingTask task;

  @override
  Widget build(BuildContext context) {
    final time = task.scheduledAt.toLocal();
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return _Card(
      child: Row(
        children: [
          Text(
            '$hour:$minute',
            style: AppTypography.titleLarge.copyWith(color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              task.title,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.onBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoneTile extends StatelessWidget {
  const _ZoneTile({required this.zone});

  final HomeZone zone;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(
        children: [
          const Icon(Icons.place_outlined, color: AppColors.primary, size: 28),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              zone.name,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.onBackground,
              ),
            ),
          ),
          Text(
            '${zone.radiusMeters.round()} m',
            style: AppTypography.bodyLarge.copyWith(color: AppColors.onSurface),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        child,
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        boxShadow: AppShadows.sm,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: child,
      ),
    );
  }
}

class _EmptyText extends StatelessWidget {
  const _EmptyText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.bodyLarge.copyWith(color: AppColors.onSurface),
    );
  }
}

class _StatusMessage extends StatelessWidget {
  const _StatusMessage({required this.text, this.actionLabel, this.onPressed});

  final String text;
  final String? actionLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.onBackground,
            ),
          ),
          if (actionLabel != null && onPressed != null) ...[
            const SizedBox(height: AppSpacing.lg),
            AppButton.primary(label: actionLabel!, onPressed: onPressed),
          ],
        ],
      ),
    );
  }
}
