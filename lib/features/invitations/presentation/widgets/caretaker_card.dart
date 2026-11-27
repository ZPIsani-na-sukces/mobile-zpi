import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/invitations/controllers/invitations_controller.dart';
import 'package:mobile_zpi/features/invitations/data/models/care_invitation.dart';
import 'package:mobile_zpi/keys.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';
import 'package:mobile_zpi/widgets/app_card.dart';
import 'package:mobile_zpi/widgets/app_initials_avatar.dart';

class CaretakerCard extends ConsumerWidget {
  const CaretakerCard({
    super.key,
    required this.seniorId,
    required this.relationship,
  });

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

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppInitialsAvatar(name: name),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  name,
                  style: AppTypography.titleLarge.copyWith(
                    color: context.colors.onBackground,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Divider(height: 1, thickness: 1, color: context.colors.outline),
          const SizedBox(height: AppSpacing.sm),
          AppButton.text(
            key: keys.caretakers.removeButton(relationship.relationshipId),
            label: 'Usuń opiekuna',
            onPressed: onRemove,
          ),
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
            key: keys.caretakers.removeConfirmButton,
            label: 'Usuń',
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );
  }
}
