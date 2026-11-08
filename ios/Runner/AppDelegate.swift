import Flutter
import UIKit
import UserNotifications
import flutter_secure_storage_darwin
import geolocator_apple
import home_widget

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Lets flutter_local_notifications show reminders and handle taps.
    UNUserNotificationCenter.current().delegate = self
    if #available(iOS 17, *) {
      // Only what sosWidgetTask needs, so background location tracking stays on the app engine.
      HomeWidgetBackgroundWorker.setPluginRegistrantCallback { registry in
        HomeWidgetPlugin.register(with: registry.registrar(forPlugin: "HomeWidgetPlugin")!)
        FlutterSecureStorageDarwinPlugin.register(
          with: registry.registrar(forPlugin: "FlutterSecureStorageDarwinPlugin")!)
        GeolocatorPlugin.register(with: registry.registrar(forPlugin: "GeolocatorPlugin")!)
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
