import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/invitations/controllers/invitations_controller.dart';
import 'package:mobile_zpi/features/invitations/presentation/widgets/caretaker_list.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/widgets/app_button.dart';
import 'package:mobile_zpi/widgets/back_scaffold.dart';

@RoutePage()
class CaretakersView extends ConsumerWidget {
  const CaretakersView({super.key, required this.seniorId});

  final String seniorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = caretakersControllerProvider(seniorId);

    Future<void> openAddCaretaker() async {
      await context.router.push(AddCaretakerRoute(seniorId: seniorId));
      ref.invalidate(provider);
    }

    return BackScaffold(
      title: 'Opiekunowie',
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          CaretakerList(seniorId: seniorId),
          const SizedBox(height: AppSpacing.xl),
          AppButton.primary(
            label: 'Dodaj opiekuna',
            icon: Icons.person_add,
            onPressed: openAddCaretaker,
          ),
        ],
      ),
    );
  }
}
