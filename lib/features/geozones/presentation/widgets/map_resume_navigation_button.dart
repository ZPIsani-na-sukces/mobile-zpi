import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/geozones/controllers/map_follow_controller.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/widgets/app_button.dart';

class MapResumeNavigationButton extends ConsumerWidget {
  const MapResumeNavigationButton({super.key});

  static const Duration _animationDuration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final following = ref.watch(mapFollowControllerProvider);

    return AnimatedSwitcher(
      duration: _animationDuration,
      child: following
          ? const SizedBox.shrink()
          : DecoratedBox(
              decoration: const BoxDecoration(
                borderRadius: AppRadius.lgAll,
                boxShadow: AppShadows.md,
              ),
              child: AppButton.primary(
                label: 'Prowadź mnie',
                icon: Icons.navigation,
                onPressed: ref
                    .read(mapFollowControllerProvider.notifier)
                    .follow,
              ),
            ),
    );
  }
}
