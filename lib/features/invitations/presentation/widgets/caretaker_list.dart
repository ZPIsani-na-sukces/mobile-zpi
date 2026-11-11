import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/invitations/controllers/invitations_controller.dart';
import 'package:mobile_zpi/features/invitations/presentation/widgets/caretaker_card.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';

class CaretakerList extends ConsumerWidget {
  const CaretakerList({super.key, required this.seniorId});

  final String seniorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = caretakersControllerProvider(seniorId);
    final textStyle = AppTypography.bodyLarge.copyWith(
      color: context.colors.onSurface,
    );

    return switch (ref.watch(provider)) {
      AsyncData(value: final items) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.sm,
        children: [
          for (final relationship in items)
            CaretakerCard(seniorId: seniorId, relationship: relationship),
        ],
      ),
      AsyncError() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.sm,
        children: [
          Text('Nie udało się wczytać opiekunów.', style: textStyle),
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
