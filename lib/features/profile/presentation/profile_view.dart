import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/config/app_env.dart';
import 'package:mobile_zpi/features/invitations/controllers/invitations_controller.dart';
import 'package:mobile_zpi/features/profile/controllers/home_address_controller.dart';
import 'package:mobile_zpi/features/profile/controllers/profile_controller.dart';
import 'package:mobile_zpi/features/profile/data/models/account.dart';
import 'package:mobile_zpi/features/profile/presentation/widgets/dev_section.dart';
import 'package:mobile_zpi/features/profile/presentation/widgets/high_contrast_switch.dart';
import 'package:mobile_zpi/features/profile/presentation/widgets/logout_button.dart';
import 'package:mobile_zpi/features/profile/presentation/widgets/profile_info_card.dart';
import 'package:mobile_zpi/features/profile/presentation/widgets/profile_info_row.dart';
import 'package:mobile_zpi/keys.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_action_card.dart';
import 'package:mobile_zpi/widgets/app_button.dart';
import 'package:mobile_zpi/widgets/app_no_connection_info.dart';

@RoutePage()
class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);

    return switch (profile) {
      AsyncData(value: final account) => _ProfileBody(account: account),
      AsyncError() => AppNoConnectionInfo(
        onRetry: () => ref.invalidate(profileControllerProvider),
        secondaryAction: const LogoutButton(),
      ),
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _ProfileBody extends ConsumerWidget {
  const _ProfileBody({required this.account});

  final Account account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final address = ref.watch(homeAddressControllerProvider(account.userId));
    final caretakers = caretakersControllerProvider(account.userId);
    ref.watch(caretakers);

    Future<void> openCaretakers() async {
      final hasCaretakers = await ref
          .read(caretakers.future)
          .then((items) => items.isNotEmpty, onError: (_) => true);
      if (!context.mounted) return;
      await context.router.push(
        hasCaretakers
            ? CaretakersRoute(seniorId: account.userId)
            : AddCaretakerRoute(seniorId: account.userId),
      );
      if (context.mounted) ref.invalidate(caretakers);
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        AppActionCard(
          key: keys.profile.caretakersCard,
          icon: Icons.group,
          title: 'Opiekunowie',
          subtitle: 'Zobacz swoich opiekunów i zaproś nowych',
          onTap: openCaretakers,
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          'Twoje dane osobowe',
          style: AppTypography.titleLarge.copyWith(
            color: context.colors.onBackground,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ProfileInfoCard(
          rows: [
            ProfileInfoRow(
              key: keys.profile.nameRow,
              label: 'Imię i nazwisko',
              value: '${account.firstName} ${account.lastName}',
            ),
            ProfileInfoRow(label: 'Telefon', value: account.phoneNumber),
            ProfileInfoRow(
              key: keys.profile.emailRow,
              label: 'E-mail',
              value: account.email ?? 'Brak adresu e-mail',
            ),
            ProfileInfoRow(
              label: 'Telefon potwierdzony',
              value: account.phoneVerified ? 'Tak' : 'Nie',
            ),
            ProfileInfoRow(
              key: keys.profile.emailVerifiedRow,
              label: 'E-mail potwierdzony',
              value: account.emailVerified ? 'Tak' : 'Nie',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Adres domu',
          style: AppTypography.titleLarge.copyWith(
            color: context.colors.onBackground,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        switch (address) {
          AsyncData(:final value) => ProfileInfoCard(
            rows: [
              ProfileInfoRow(
                key: keys.profile.addressRow,
                label: 'Adres',
                value:
                    value?.formattedAddress ?? 'Brak ustawionego adresu domu',
              ),
            ],
          ),
          AsyncError() => const ProfileInfoCard(
            rows: [
              ProfileInfoRow(
                label: 'Adres',
                value: 'Nie udało się wczytać adresu.',
              ),
            ],
          ),
          AsyncLoading() => const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Center(child: CircularProgressIndicator()),
          ),
        },
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Dostępność',
          style: AppTypography.titleLarge.copyWith(
            color: context.colors.onBackground,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        HighContrastSwitch(key: keys.profile.highContrastSwitch),
        const SizedBox(height: AppSpacing.xxl),
        AppButton.primary(
          key: keys.profile.editButton,
          label: 'Edytuj',
          onPressed: () => context.router.push(const ProfileEditRoute()),
        ),
        const SizedBox(height: AppSpacing.md),
        LogoutButton(key: keys.profile.logoutButton),
        if (AppEnv.isDev) ...[
          const SizedBox(height: AppSpacing.xl),
          DevSection(seniorId: account.userId),
        ],
      ],
    );
  }
}
