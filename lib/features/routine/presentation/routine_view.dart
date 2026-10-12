import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/profile/controllers/profile_controller.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/widgets/app_button.dart';

@RoutePage()
class RoutineView extends ConsumerWidget {
  const RoutineView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) =>
            const Center(child: Text('Nie udało się wczytać profilu.')),
        data: (account) => Align(
          alignment: Alignment.topCenter,
          child: AppButton.primary(
            label: 'Nowe zadanie',
            onPressed: () => context.router.push(
              CreateRoutineTaskRoute(seniorId: account.userId),
            ),
          ),
        ),
      ),
    );
  }
}
