import AppIntents
import Foundation

#if !WIDGET_EXTENSION
  import home_widget
#endif

/// Shared with `homeWidgetsAppGroup` in Dart and both entitlements files.
let homeWidgetsAppGroup = "group.com.example.mobileZpi"

/// Runs `sosWidgetTask` in Dart when the SOS widget is tapped.
///
/// This file is compiled into the app and the widget extension. Only the app
/// copy conforms to `ForegroundContinuableIntent`, so iOS performs the intent
/// in the app process, where Flutter runs, without bringing the app forward.
@available(iOS 17, *)
struct SosIntent: AppIntent {
  static var title: LocalizedStringResource = "Wezwij pomoc"
  static var isDiscoverable = false

  func perform() async throws -> some IntentResult {
    #if !WIDGET_EXTENSION
      await HomeWidgetBackgroundWorker.run(
        url: URL(string: "zpi://sos"), appGroup: homeWidgetsAppGroup)
    #endif
    return .result()
  }
}

#if !WIDGET_EXTENSION
  @available(iOS 17, *)
  extension SosIntent: ForegroundContinuableIntent {}
#endif
