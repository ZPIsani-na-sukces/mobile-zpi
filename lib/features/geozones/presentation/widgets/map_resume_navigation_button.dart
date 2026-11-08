import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/geozones/controllers/map_follow_controller.dart';
import 'package:mobile_zpi/widgets/app_button.dart';

class MapResumeNavigationButton extends ConsumerWidget {
  const MapResumeNavigationButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppButton.primary(
      label: 'Wyśrodkuj',
      icon: Icons.navigation,
      onPressed: ref.read(mapFollowControllerProvider.notifier).follow,
    );
  }
}
