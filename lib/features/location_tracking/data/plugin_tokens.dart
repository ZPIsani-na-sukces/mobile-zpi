import 'package:flutter/foundation.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:mobile_zpi/features/auth/shared/data/jwt_issued_at.dart';
import 'package:mobile_zpi/features/auth/shared/data/models/auth_session.dart';
import 'package:mobile_zpi/features/location_tracking/data/location_tracking_config.dart';

Future<AuthSession?> sessionWithNewerPluginTokens(AuthSession session) async {
  try {
    final pluginAuth = (await bg.BackgroundGeolocation.state).authorization;
    final accessToken = pluginAuth?.accessToken;
    final refreshToken = pluginAuth?.refreshToken;
    if (accessToken == null || refreshToken == null) return null;

    final pluginIssuedAt = jwtIssuedAt(accessToken);
    final appIssuedAt = jwtIssuedAt(session.accessToken);
    if (pluginIssuedAt == null ||
        appIssuedAt == null ||
        !pluginIssuedAt.isAfter(appIssuedAt)) {
      return null;
    }

    return session.copyWith(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  } catch (e) {
    debugPrint('Reading plugin tokens failed: $e');
    return null;
  }
}

Future<void> sendTokensToPlugin(AuthSession session) async {
  try {
    final pluginAuth = (await bg.BackgroundGeolocation.state).authorization;
    if (pluginAuth?.refreshToken == null) return;

    await bg.BackgroundGeolocation.setConfig(
      bg.Config(authorization: buildLocationTrackingAuthorization(session)),
    );
  } catch (e) {
    debugPrint('Updating plugin tokens failed: $e');
  }
}
