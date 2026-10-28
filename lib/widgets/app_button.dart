import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

enum AppButtonVariant { primary, secondary, text }

/// Design system button. Pass `onPressed: null` to render the disabled state.
class AppButton extends HookWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
  });

  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  }) : variant = AppButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  }) : variant = AppButtonVariant.text;

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;

  static const double _height = 48;
  static const double _borderWidth = 2;
  // Press reacts almost instantly, release eases out more softly.
  static const Duration _pressDuration = Duration(milliseconds: 75);
  static const Curve _pressCurve = Curves.easeOut;
  static const Duration _releaseDuration = Duration(milliseconds: 200);
  static const Curve _releaseCurve = Curves.easeInOut;

  static const Duration _minPressedDuration = Duration(milliseconds: 100);

  @override
  Widget build(BuildContext context) {
    final pressedState = useState(false);
    final pressStopwatch = useMemoized(Stopwatch.new);
    final releaseTimer = useRef<Timer?>(null);
    useEffect(
      () =>
          () => releaseTimer.value?.cancel(),
      const [],
    );

    final enabled = onPressed != null;
    useEffect(() {
      if (!enabled) {
        releaseTimer.value?.cancel();
        pressedState.value = false;
      }
      return null;
    }, [enabled]);

    void press() {
      releaseTimer.value?.cancel();
      pressStopwatch
        ..reset()
        ..start();
      pressedState.value = true;
    }

    void release() {
      final remaining = _minPressedDuration - pressStopwatch.elapsed;
      if (remaining <= Duration.zero) {
        pressedState.value = false;
      } else {
        releaseTimer.value = Timer(remaining, () => pressedState.value = false);
      }
    }

    final pressed = enabled && pressedState.value;

    final palette = context.colors;
    final colors = _resolveColors(palette, enabled: enabled, pressed: pressed);
    // In high contrast a text button differs from body text by more than hue.
    final underline =
        palette.isHighContrast && variant == AppButtonVariant.text;
    final horizontalPadding = variant == AppButtonVariant.text
        ? AppSpacing.sm
        : AppSpacing.md;
    final duration = pressed ? _pressDuration : _releaseDuration;
    final curve = pressed ? _pressCurve : _releaseCurve;

    return Semantics(
      button: true,
      enabled: enabled,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onPressed,
          onTapDown: enabled ? (_) => press() : null,
          onTapUp: enabled ? (_) => release() : null,
          onTapCancel: enabled ? release : null,
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          borderRadius: AppRadius.lgAll,
          child: AnimatedContainer(
            duration: duration,
            curve: curve,
            height: _height,
            padding: EdgeInsets.symmetric(
              vertical: AppSpacing.sm,
              horizontal: horizontalPadding,
            ),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: AppRadius.lgAll,
              boxShadow: colors.shadow,
            ),
            // Border painted on top so it doesn't change the button's size.
            foregroundDecoration: BoxDecoration(
              borderRadius: AppRadius.lgAll,
              border: Border.all(
                color: colors.border ?? Colors.transparent,
                width: _borderWidth,
              ),
            ),
            child: TweenAnimationBuilder<Color?>(
              tween: ColorTween(end: colors.foreground),
              duration: duration,
              curve: curve,
              builder: (context, color, child) => Center(
                widthFactor: 1,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: AppSpacing.sm,
                    children: [
                      if (icon != null) Icon(icon, color: color, size: 20),
                      Text(
                        label,
                        style: AppTypography.labelLarge.copyWith(
                          color: color,
                          decoration: underline
                              ? TextDecoration.underline
                              : null,
                          decorationColor: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _ButtonColors _resolveColors(
    AppColors colors, {
    required bool enabled,
    required bool pressed,
  }) {
    if (!enabled) {
      return switch (variant) {
        AppButtonVariant.primary => _ButtonColors(
          background: colors.disabled,
          foreground: colors.onDisabled,
        ),
        AppButtonVariant.secondary => _ButtonColors(
          foreground: colors.onDisabled,
          border: colors.disabled,
        ),
        AppButtonVariant.text => _ButtonColors(foreground: colors.onDisabled),
      };
    }

    return switch (variant) {
      AppButtonVariant.primary => _ButtonColors(
        background: pressed ? colors.primaryVariant : colors.primary,
        foreground: colors.onPrimary,
        shadow: pressed ? const [] : AppShadows.xs,
      ),
      AppButtonVariant.secondary =>
        pressed
            ? _ButtonColors(
                background: colors.primary,
                foreground: colors.onPrimary,
                border: colors.primary,
              )
            : _ButtonColors(foreground: colors.primary, border: colors.primary),
      AppButtonVariant.text => _ButtonColors(
        background: pressed ? colors.surfacePressed : Colors.transparent,
        foreground: pressed ? colors.primaryVariant : colors.primary,
      ),
    };
  }
}

class _ButtonColors {
  const _ButtonColors({
    required this.foreground,
    this.background = Colors.transparent,
    this.border,
    this.shadow = const [],
  });

  final Color background;
  final Color foreground;
  final Color? border;
  final List<BoxShadow> shadow;
}
