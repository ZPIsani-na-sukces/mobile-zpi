import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/auth/shared/controllers/auth_controller.dart';
import 'package:mobile_zpi/features/home_widgets/data/home_widgets.dart';
import 'package:mobile_zpi/features/profile/controllers/home_address_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_widgets_controller.g.dart';

/// Keeps the back home widget in sync with the session and home address.
@Riverpod(keepAlive: true)
class HomeWidgetsController extends _$HomeWidgetsController {
  @override
  void build() {
    final seniorId = ref.watch(
      authControllerProvider.select((auth) => auth.value?.user.userId),
    );

    if (seniorId == null) {
      _run(() => saveBackHomeWidgetHasAddress(false));
      return;
    }

    ref.listen(homeAddressControllerProvider(seniorId), (_, next) {
      if (next case AsyncData(:final value)) {
        _run(() => saveBackHomeWidgetHasAddress(value != null));
      }
    }, fireImmediately: true);
  }

  void _run(Future<void> Function() update) {
    update().catchError((Object e) => debugPrint('Widget update failed: $e'));
  }
}
