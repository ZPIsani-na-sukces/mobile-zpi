import 'package:flutter/foundation.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:mobile_zpi/features/auth/shared/controllers/auth_controller.dart';
import 'package:mobile_zpi/features/auth/shared/data/jwt_issued_at.dart';
import 'package:mobile_zpi/features/auth/shared/data/models/auth_session.dart';
import 'package:mobile_zpi/features/location_tracking/data/location_tracking_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_tracking_controller.g.dart';

@Riverpod(keepAlive: true)
class LocationTrackingController extends _$LocationTrackingController {
  var _isReady = false;
  var _isFirstSync = true;
  var _syncQueue = Future<void>.value();

  @override
  void build() {
    final heartbeat = bg.BackgroundGeolocation.onHeartbeat((_) async {
      try {
        await bg.BackgroundGeolocation.getCurrentPosition(
          samples: 1,
          persist: true,
        );
      } catch (e) {
        debugPrint('Heartbeat location failed: $e');
      }
    });
    final authorization = bg.BackgroundGeolocation.onAuthorization(
      _onAuthorization,
    );
    ref.onDispose(() {
      heartbeat.remove();
      authorization.remove();
    });

    ref.listen(authControllerProvider, (_, next) {
      if (next.isLoading) return;
      _syncQueue = _syncQueue
          .then((_) => _sync(next.value))
          .catchError((Object e) => debugPrint('Location sync failed: $e'));
    }, fireImmediately: true);
  }

  Future<void> _onAuthorization(bg.AuthorizationEvent event) async {
    final auth = ref.read(authControllerProvider.notifier);

    try {
      if (!event.success) {
        if (event.status == 401 || event.status == 403) await auth.logout();
        return;
      }

      final session = ref.read(authControllerProvider).value;
      if (session == null) return;

      if (event.response case {
        'accessToken': final String accessToken,
        'refreshToken': final String refreshToken,
      }) {
        await auth.setSession(
          session.copyWith(
            accessToken: accessToken,
            refreshToken: refreshToken,
          ),
        );
      }
    } catch (e) {
      debugPrint('Token update failed: $e');
    }
  }

  Future<void> _sync(AuthSession? session) async {
    final isFirstSync = _isFirstSync;
    _isFirstSync = false;

    if (session == null || session.user.role.toUpperCase() != 'SENIOR') {
      await bg.BackgroundGeolocation.stop();
      await bg.BackgroundGeolocation.destroyLocations();
      await bg.BackgroundGeolocation.reset();
      return;
    }

    if (isFirstSync && await _hasNewerPluginTokens(session)) return;

    final config = buildLocationTrackingConfig(session);
    if (_isReady) {
      await bg.BackgroundGeolocation.setConfig(config);
    } else {
      await bg.BackgroundGeolocation.ready(config);
      _isReady = true;
    }
    await bg.BackgroundGeolocation.start();
  }

  Future<bool> _hasNewerPluginTokens(AuthSession session) async {
    final pluginAuth = (await bg.BackgroundGeolocation.state).authorization;
    final accessToken = pluginAuth?.accessToken;
    final refreshToken = pluginAuth?.refreshToken;

    if (accessToken == null || refreshToken == null) return false;

    final pluginIssuedAt = jwtIssuedAt(accessToken);
    final appIssuedAt = jwtIssuedAt(session.accessToken);
    if (pluginIssuedAt == null ||
        appIssuedAt == null ||
        !pluginIssuedAt.isAfter(appIssuedAt)) {
      return false;
    }

    await ref
        .read(authControllerProvider.notifier)
        .setSession(
          session.copyWith(
            accessToken: accessToken,
            refreshToken: refreshToken,
          ),
        );
    return true;
  }
}
