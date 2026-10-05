import 'package:flutter/foundation.dart';

/// Values injected at compile time via `--dart-define-from-file=.env`.
abstract final class AppEnv {
  static const String _env = String.fromEnvironment('APP_ENV');

  /// When `APP_ENV` is not set, debug builds are DEV and release/profile
  /// builds are PROD.
  static const bool isDev = _env == 'DEV' || (_env == '' && kDebugMode);
  static const bool isProd = !isDev;
}
