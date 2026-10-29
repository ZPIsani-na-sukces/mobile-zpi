import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

class LocationLoading extends HookWidget {
  const LocationLoading({super.key});

  static const _messageDelay = Duration(seconds: 3);
  static const _hintDelay = Duration(seconds: 6);
  static const _fadeDuration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final stage = useState(0);

    useEffect(() {
      final timers = [
        Timer(_messageDelay, () => stage.value = 1),
        Timer(_hintDelay, () => stage.value = 2),
      ];
      return () {
        for (final timer in timers) {
          timer.cancel();
        }
      };
    }, const []);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.lg,
          children: [
            const CircularProgressIndicator(),
            Column(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.sm,
              children: [
                AnimatedOpacity(
                  opacity: stage.value >= 1 ? 1 : 0,
                  duration: _fadeDuration,
                  child: Text(
                    'Szukamy Twojej lokalizacji…',
                    textAlign: TextAlign.center,
                    style: AppTypography.titleLarge.copyWith(
                      color: context.colors.onBackground,
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: stage.value >= 2 ? 1 : 0,
                  duration: _fadeDuration,
                  child: Text(
                    'Jeśli jesteś w budynku, podejdź do okna',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyLarge.copyWith(
                      color: context.colors.onBackground,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
