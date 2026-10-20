import AppIntents
import SwiftUI
import WidgetKit

// Mirrors AppColors in lib/theme/app_colors.dart.
private let primary = Color(red: 0x00 / 255, green: 0x67 / 255, blue: 0xB8 / 255)
private let error = Color(red: 0xC6 / 255, green: 0x28 / 255, blue: 0x28 / 255)

@main
struct HomeWidgets: WidgetBundle {
  var body: some Widget {
    SosWidget()
    BackHomeWidget()
  }
}

struct StoredEntry: TimelineEntry {
  let date = Date()
  let value: String?
}

/// Reads one value saved from Dart with `HomeWidget.saveWidgetData`.
struct StoredProvider: TimelineProvider {
  let key: String

  func placeholder(in context: Context) -> StoredEntry {
    StoredEntry(value: nil)
  }

  func getSnapshot(in context: Context, completion: @escaping (StoredEntry) -> Void) {
    completion(StoredEntry(value: UserDefaults(suiteName: homeWidgetsAppGroup)?.string(forKey: key)))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<StoredEntry>) -> Void) {
    getSnapshot(in: context) { completion(Timeline(entries: [$0], policy: .never)) }
  }
}

struct SosWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: "SosWidget", provider: StoredProvider(key: "sos_status")) { entry in
      Button(intent: SosIntent()) {
        VStack(spacing: 4) {
          Text("SOS").font(.system(size: 44, weight: .bold))
          Text(entry.value ?? "Dotknij, aby wezwać pomoc")
            .font(.subheadline)
            .multilineTextAlignment(.center)
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
      }
      .buttonStyle(.plain)
      .foregroundStyle(.white)
      .containerBackground(error, for: .widget)
    }
    .configurationDisplayName("SOS")
    .description("Wzywa pomoc opiekuna jednym dotknięciem.")
    .supportedFamilies([.systemSmall])
    .contentMarginsDisabled()
  }
}

struct BackHomeWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: "BackHomeWidget", provider: StoredProvider(key: "back_home_url")) {
      entry in
      Button(intent: BackHomeIntent(url: entry.value.flatMap(URL.init(string:)))) {
        VStack(spacing: 4) {
          Image(systemName: "house.fill").font(.system(size: 40))
          Text("Wróć do domu").font(.headline)
          if entry.value == nil {
            Text("Brak adresu domu").font(.subheadline)
          }
        }
        .multilineTextAlignment(.center)
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
      }
      .buttonStyle(.plain)
      .foregroundStyle(.white)
      .containerBackground(primary, for: .widget)
    }
    .configurationDisplayName("Wróć do domu")
    .description("Otwiera nawigację do domu w Google Maps.")
    .supportedFamilies([.systemSmall])
    .contentMarginsDisabled()
  }
}

/// Opens Google Maps straight from the widget, without the app.
struct BackHomeIntent: AppIntent {
  static var title: LocalizedStringResource = "Wróć do domu"
  static var isDiscoverable = false

  @Parameter(title: "URL")
  var url: URL?

  init() {}

  init(url: URL?) {
    self.url = url
  }

  func perform() async throws -> some IntentResult & OpensIntent {
    guard let url else { throw MissingHomeError() }
    return .result(opensIntent: OpenURLIntent(url))
  }
}

struct MissingHomeError: Error {}
