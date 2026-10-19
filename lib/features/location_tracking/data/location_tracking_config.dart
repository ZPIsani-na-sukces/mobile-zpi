import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:mobile_zpi/config/app_env.dart';
import 'package:mobile_zpi/features/auth/shared/data/models/auth_session.dart';

bg.Config buildLocationTrackingConfig(AuthSession session) => bg.Config(
  geolocation: const bg.GeoConfig(
    desiredAccuracy: bg.DesiredAccuracy.high,
    distanceFilter: 8,
    stationaryRadius: 25,
    stopTimeout: 10,
    locationAuthorizationRequest: 'Always',
    disableLocationAuthorizationAlert: false,

    // iOS only
    locationAuthorizationAlert: {
      'titleWhenNotEnabled': 'Usługi lokalizacyjne wyłączone',
      'titleWhenOff': 'Wymagane uprawnienia do lokalizacji',
      'instructions': 'Aplikacja wymaga uprawnienia "Zawsze", aby śledzić Twoją lokalizację. Prosimy o zaktualizowanie ustawień.',
      'cancelButton': 'Anuluj',
      'settingsButton': 'Otwórz ustawienia',
    },
    showsBackgroundLocationIndicator:
        true, // can be tapped to return to the app
    activityType: bg.ActivityType.other,
  ),
  app: bg.AppConfig(
    stopOnTerminate: false,
    startOnBoot: true,
    heartbeatInterval: 300, // in stationary check every 5 min
    // iOS only
    preventSuspend: true,
    // Android only
    backgroundPermissionRationale: bg.PermissionRationale(
      title: 'Wymagana lokalizacja w tle',
      message: 'Aby rejestrować Twoją lokalizację po zablokowaniu ekranu, aplikacja potrzebuje pełnego dostępu. W następnym oknie wybierz opcję "{backgroundPermissionOptionLabel}".',
      positiveAction: 'Przejdź do Ustawień',
      negativeAction: 'Anuluj',
    ),
    notification: bg.Notification(
      title: 'Śledzenie lokalizacji',
      text: 'Twoja pozycja jest udostępniana opiekunowi.',
      largeIcon: 'mipmap/ic_launcher',
      smallIcon: 'drawable/small_eldery_icon',
      channelName: 'Usługa lokalizacji',
      priority: bg.NotificationPriority.low,
    ),
    enableHeadless: true,
  ),
  http: bg.HttpConfig(
    url: '${AppEnv.apiBaseUrl}/locations', // TODO
    method: 'POST',
    params: {'device_id': 'abc123'}, // TODO: match with backend
    autoSync: true,
    batchSync: false,
  ),
  persistence: const bg.PersistenceConfig(maxDaysToPersist: 1),
  activity: const bg.ActivityConfig(
    motionTriggerDelay:
        10000, // (ms) prevent false positives while mobing at home
    disableStopDetection: false,
    stopOnStationary: false,
  ),
  logger: const bg.LoggerConfig(
    debug: AppEnv.isDev,
    logLevel: AppEnv.isDev ? bg.LogLevel.debug : bg.LogLevel.error,
  ),
  authorization: bg.Authorization(
    strategy: 'jwt',
    accessToken: session.accessToken,
    refreshToken: session.refreshToken,
    refreshUrl: '${AppEnv.apiBaseUrl}/auth/refresh',
    refreshPayload: {'clientType': 'mobile', 'refreshToken': '{refreshToken}'},
    refreshHeaders: {'Content-Type': 'application/json'},
  ),
);
