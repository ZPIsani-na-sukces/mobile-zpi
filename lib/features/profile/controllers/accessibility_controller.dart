import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mobile_zpi/features/profile/controllers/profile_controller.dart';
import 'package:mobile_zpi/features/profile/data/accessibility_storage.dart';
import 'package:mobile_zpi/features/profile/data/models/accessibility_preferences.dart';
import 'package:mobile_zpi/features/profile/data/repository/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accessibility_controller.g.dart';

/// Accessibility preferences of the senior from the profile.
@Riverpod(keepAlive: true)
class AccessibilityController extends _$AccessibilityController {
  // A caregiver can change the preferences remotely and no live event covers
  // them, so they are polled like other screens without live updates.
  static const Duration _refreshInterval = Duration(seconds: 15);

  @override
  Future<AccessibilityPreferences> build() async {
    final seniorId = await ref.watch(
      profileControllerProvider.selectAsync((account) => account.userId),
    );

    _scheduleRefresh();
    return ref
        .watch(profileRepositoryProvider)
        .getAccessibilityPreferences(seniorId);
  }

  Future<void> setHighContrast(bool enabled) async {
    final current = await future;
    final changed = current.copyWith(highContrastEnabled: enabled);
    state = AsyncData(changed);
    try {
      state = AsyncData(
        await ref
            .read(profileRepositoryProvider)
            .saveAccessibilityPreferences(changed),
      );
    } catch (_) {
      state = AsyncData(current);
      // The save fails with 412 when a caregiver changed the preferences in
      // the meantime, so load the current version before the next try.
      ref.invalidateSelf();
      rethrow;
    }
  }

  void _scheduleRefresh() {
    final timer = Timer(_refreshInterval, () {
      final appState = WidgetsBinding.instance.lifecycleState;
      if (appState == AppLifecycleState.resumed) ref.invalidateSelf();
    });
    final lifecycle = AppLifecycleListener(onResume: ref.invalidateSelf);
    ref.onDispose(() {
      timer.cancel();
      lifecycle.dispose();
    });
  }
}

/// High contrast flag the app theme renders. Starts from the value stored on
/// the device and follows the preferences loaded from the API, keeping the
/// last known value while signed out.
@Riverpod(keepAlive: true)
class HighContrastController extends _$HighContrastController {
  @override
  Future<bool> build() async {
    final storage = ref.watch(accessibilityStorageProvider);
    final stored = await storage.readHighContrast();

    ref.listen(accessibilityControllerProvider, (_, next) {
      final enabled = next.value?.highContrastEnabled;
      if (enabled == null || enabled == state.value) return;
      state = AsyncData(enabled);
      unawaited(storage.writeHighContrast(enabled));
    });

    return stored;
  }
}
