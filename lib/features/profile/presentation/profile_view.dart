import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/config/app_env.dart';
import 'package:mobile_zpi/features/profile/controllers/home_address_controller.dart';
import 'package:mobile_zpi/features/profile/controllers/profile_controller.dart';
import 'package:mobile_zpi/features/profile/data/models/account.dart';
import 'package:mobile_zpi/features/profile/presentation/profile_messages.dart';
import 'package:mobile_zpi/features/profile/presentation/widgets/dev_section.dart';
import 'package:mobile_zpi/features/profile/presentation/widgets/logout_button.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';
import 'package:mobile_zpi/widgets/back_scaffold.dart';

@RoutePage()
class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);

    return BackScaffold(
      title: 'Profil',
      body: switch (profile) {
        AsyncData(value: final account) => _ProfileBody(account: account),
        AsyncError() => _Message(
          text: 'Nie udało się wczytać profilu.',
          actionLabel: 'Spróbuj ponownie',
          onPressed: () => ref.invalidate(profileControllerProvider),
        ),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _ProfileBody extends ConsumerWidget {
  const _ProfileBody({required this.account});

  final Account account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final address = ref.watch(homeAddressControllerProvider(account.userId));

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(
          '${account.firstName} ${account.lastName}',
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          accountStatusLabel(account.status),
          style: AppTypography.bodyLarge.copyWith(color: AppColors.onSurface),
        ),
        const SizedBox(height: AppSpacing.lg),
        _InfoCard(
          rows: [
            _InfoRow(label: 'Telefon', value: account.phoneNumber),
            _InfoRow(
              label: 'E-mail',
              value: account.email ?? 'Brak adresu e-mail',
            ),
            _InfoRow(
              label: 'Telefon potwierdzony',
              value: account.phoneVerified ? 'Tak' : 'Nie',
            ),
            _InfoRow(
              label: 'E-mail potwierdzony',
              value: account.emailVerified ? 'Tak' : 'Nie',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Adres domu',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        switch (address) {
          AsyncData(:final value) => _InfoCard(
            rows: [
              _InfoRow(
                label: 'Adres',
                value:
                    value?.formattedAddress ?? 'Brak ustawionego adresu domu',
              ),
            ],
          ),
          AsyncError() => const _InfoCard(
            rows: [
              _InfoRow(label: 'Adres', value: 'Nie udało się wczytać adresu.'),
            ],
          ),
          AsyncLoading() => const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Center(child: CircularProgressIndicator()),
          ),
        },
        const SizedBox(height: AppSpacing.xl),
        AppButton.primary(
          label: 'Edytuj',
          onPressed: () => context.router.push(const ProfileEditRoute()),
        ),
        const SizedBox(height: AppSpacing.md),
        const LogoutButton(),
        if (AppEnv.isDev) ...[
          const SizedBox(height: AppSpacing.xl),
          DevSection(seniorId: account.userId),
        ],
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.rows});

  final List<_InfoRow> rows;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.md),
              rows[i],
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.onSurface,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.onBackground,
            ),
          ),
        ),
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.text,
    required this.actionLabel,
    required this.onPressed,
  });

  final String text;
  final String actionLabel;
  final VoidCallback onPressed;

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
          const SizedBox(height: AppSpacing.lg),
          AppButton.primary(label: actionLabel, onPressed: onPressed),
        ],
      ),
    );
  }
}
