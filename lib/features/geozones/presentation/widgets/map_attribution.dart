import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/map_circle_button.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

class MapAttribution extends HookWidget {
  const MapAttribution({super.key});

  static const _initialDisplayDuration = Duration(seconds: 5);

  @override
  Widget build(BuildContext context) {
    final isOpen = useState(true);
    final hideTimer = useRef<Timer?>(null);

    useEffect(() {
      hideTimer.value = Timer(
        _initialDisplayDuration,
        () => isOpen.value = false,
      );
      return () => hideTimer.value?.cancel();
    }, const []);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Align(
          alignment: Alignment.topRight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MapCircleButton(
                tooltip: 'Informacje o mapie',
                onPressed: () {
                  hideTimer.value?.cancel();
                  isOpen.value = !isOpen.value;
                },
                icon: const Icon(Icons.info_outline),
              ),
              if (isOpen.value) ...[
                const SizedBox(height: AppSpacing.sm),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    border: context.colors.cardBorder,
                    borderRadius: AppRadius.mdAll,
                    boxShadow: AppShadows.md,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    child: Text(
                      '© OpenStreetMap contributors',
                      style: AppTypography.bodySmall.copyWith(
                        color: context.colors.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
