import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/invitations/controllers/invitations_controller.dart';
import 'package:mobile_zpi/features/invitations/data/invitation_exceptions.dart';
import 'package:mobile_zpi/features/invitations/data/models/care_invitation.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';
import 'package:mobile_zpi/widgets/app_code_input.dart';
import 'package:mobile_zpi/widgets/back_scaffold.dart';

@RoutePage()
class InvitationsView extends ConsumerWidget {
  const InvitationsView({super.key, required this.seniorId});

  final String seniorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BackScaffold(
      title: 'Opiekunowie',
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const _SectionTitle('Twoi opiekunowie'),
          const SizedBox(height: AppSpacing.sm),
          _CaretakerList(seniorId: seniorId),
          const SizedBox(height: AppSpacing.xl),
          const _SectionTitle('Zaproś opiekuna'),
          const SizedBox(height: AppSpacing.sm),
          const _Description(
            'Pokaż kod opiekunowi. Wpisze go w swojej aplikacji.',
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton.primary(
            label: 'Pokaż kod zaproszenia',
            icon: Icons.person_add,
            onPressed: () async {
              await context.router.push(const SendInvitationRoute());
              // The API has no way to watch a sent code, so the list is
              // loaded again in case the caregiver has just used it.
              ref.invalidate(caretakersControllerProvider(seniorId));
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          const _SectionTitle('Masz kod od opiekuna?'),
          const SizedBox(height: AppSpacing.sm),
          _CodeForm(seniorId: seniorId),
        ],
      ),
    );
  }
}

class _CaretakerList extends ConsumerWidget {
  const _CaretakerList({required this.seniorId});

  final String seniorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = caretakersControllerProvider(seniorId);

    return switch (ref.watch(provider)) {
      AsyncData(value: final items) when items.isEmpty => const _Description(
        'Nie masz jeszcze opiekuna.',
      ),
      AsyncData(value: final items) => Column(
        children: [
          for (final relationship in items) ...[
            _CaretakerCard(seniorId: seniorId, relationship: relationship),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
      AsyncError() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _Description('Nie udało się wczytać opiekunów.'),
          const SizedBox(height: AppSpacing.sm),
          AppButton.secondary(
            label: 'Spróbuj ponownie',
            onPressed: () => ref.invalidate(provider),
          ),
        ],
      ),
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _CaretakerCard extends ConsumerWidget {
  const _CaretakerCard({required this.seniorId, required this.relationship});

  final String seniorId;
  final CareRelationship relationship;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final caretaker = relationship.caretaker;
    final name = '${caretaker.firstName} ${caretaker.lastName}';

    Future<void> onRemove() async {
      final confirmed = await _confirmRemoval(context, name);
      if (confirmed != true) return;
      try {
        await ref
            .read(caretakersControllerProvider(seniorId).notifier)
            .remove(relationship.relationshipId);
      } catch (_) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nie udało się usunąć opiekuna.')),
        );
      }
    }

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            name,
            style: AppTypography.titleLarge.copyWith(
              color: context.colors.onBackground,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton.text(label: 'Usuń opiekuna', onPressed: onRemove),
        ],
      ),
    );
  }

  Future<bool?> _confirmRemoval(BuildContext context, String name) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: context.colors.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
        title: Text(
          'Usunąć opiekuna?',
          style: AppTypography.headlineSmall.copyWith(
            color: context.colors.onBackground,
          ),
        ),
        content: Text(
          '$name nie będzie już widzieć Twoich danych.',
          style: AppTypography.bodyLarge.copyWith(
            color: context.colors.onSurface,
          ),
        ),
        actions: [
          AppButton.text(
            label: 'Anuluj',
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
          AppButton.primary(
            label: 'Usuń',
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );
  }
}

class _CodeForm extends HookConsumerWidget {
  const _CodeForm({required this.seniorId});

  final String seniorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codeController = useVerificationCodeController();
    final notifier = ref.read(invitationCodeControllerProvider.notifier);
    final state = ref.watch(invitationCodeControllerProvider);

    ref.listen(invitationCodeControllerProvider, (_, next) {
      if (next.hasError) codeController.clear();
    });

    Future<void> onAccept() async {
      if (!await notifier.accept(codeController.text)) return;
      codeController.clear();
      ref.invalidate(caretakersControllerProvider(seniorId));
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Opiekun został dodany.')));
    }

    if (state case AsyncData(value: final preview?)) {
      return _InvitationCard(
        preview: preview,
        onAccept: onAccept,
        onCancel: () {
          codeController.clear();
          notifier.clear();
        },
      );
    }

    // The input stays mounted while loading, so it keeps the keyboard focus
    // for typing the code again.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCodeInput(
          label: 'Kod od opiekuna',
          controller: codeController,
          errorText: switch (state) {
            AsyncError(:final error) => _errorText(error),
            _ => null,
          },
          onChanged: (value) {
            if (value.isNotEmpty && state.hasError) notifier.clear();
          },
          onCompleted: notifier.check,
        ),
        if (state.isLoading) ...[
          const SizedBox(height: AppSpacing.md),
          const Center(child: CircularProgressIndicator()),
        ],
      ],
    );
  }

  String _errorText(Object error) {
    return switch (error) {
      InvitationCodeException(error: InvitationCodeError.invalid) =>
        'Kod jest nieprawidłowy albo wygasł.',
      InvitationCodeException(error: InvitationCodeError.notForYou) =>
        'Ten kod nie jest dla Ciebie. Poproś opiekuna o jego kod.',
      InvitationCodeException(error: InvitationCodeError.used) =>
        'Ten kod został już wykorzystany.',
      InvitationCodeException(error: InvitationCodeError.alreadyLinked) =>
        'Ten opiekun jest już połączony z Twoim kontem.',
      InvitationCodeException(error: InvitationCodeError.tooManyAttempts) =>
        'Zbyt wiele prób. Spróbuj ponownie później.',
      _ => 'Nie udało się sprawdzić kodu. Spróbuj ponownie.',
    };
  }
}

class _InvitationCard extends StatelessWidget {
  const _InvitationCard({
    required this.preview,
    required this.onAccept,
    required this.onCancel,
  });

  final InvitationPreview preview;
  final VoidCallback onAccept;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            preview.sender.firstName,
            style: AppTypography.titleLarge.copyWith(
              color: context.colors.onBackground,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          const _Description('chce zostać Twoim opiekunem.'),
          const SizedBox(height: AppSpacing.md),
          AppButton.primary(label: 'Przyjmij', onPressed: onAccept),
          const SizedBox(height: AppSpacing.sm),
          AppButton.text(label: 'Anuluj', onPressed: onCancel),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: context.colors.cardBorder,
        borderRadius: AppRadius.lgAll,
        boxShadow: AppShadows.sm,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: child,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.titleLarge.copyWith(
        color: context.colors.onBackground,
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.bodyLarge.copyWith(color: context.colors.onSurface),
    );
  }
}
