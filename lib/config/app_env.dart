import 'package:flutter/foundation.dart';

/// Values injected at compile time via `--dart-define-from-file=.env`.
abstract final class AppEnv {
  static const String _env = String.fromEnvironment('APP_ENV');

  /// When `APP_ENV` is not set, debug builds are DEV and release/profile
  /// builds are PROD.
  static const bool isDev = _env == 'DEV' || (_env == '' && kDebugMode);
  static const bool isProd = !isDev;

  /// Whether repositories should return mocked data instead of calling the
  /// API. When `USE_MOCKS` is not set, it follows [isDev].
  static const bool useMocks = bool.fromEnvironment(
    'USE_MOCKS',
    defaultValue: isDev,
  );

  /// Base URL of the backend API, e.g. `https://api.example.com`.
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL');
}
