import SwiftUI
import WidgetKit

/// Shared with `homeWidgetsAppGroup` in Dart and both entitlements files.
private let homeWidgetsAppGroup = "group.pl.zpizsws.mobile"

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

struct StoredEntry<Value>: TimelineEntry {
  let date = Date()
  let value: Value?
}

/// Reads one value saved from Dart with `HomeWidget.saveWidgetData`.
struct StoredProvider<Value>: TimelineProvider {
  let key: String

  func placeholder(in context: Context) -> StoredEntry<Value> {
    StoredEntry(value: nil)
  }

  func getSnapshot(in context: Context, completion: @escaping (StoredEntry<Value>) -> Void) {
    let value = UserDefaults(suiteName: homeWidgetsAppGroup)?.object(forKey: key) as? Value
    completion(StoredEntry(value: value))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<StoredEntry<Value>>) -> Void) {
    getSnapshot(in: context) { completion(Timeline(entries: [$0], policy: .never)) }
  }
}

struct StaticEntry: TimelineEntry {
  let date = Date()
}

/// For widgets that show no saved data.
struct StaticProvider: TimelineProvider {
  func placeholder(in context: Context) -> StaticEntry {
    StaticEntry()
  }

  func getSnapshot(in context: Context, completion: @escaping (StaticEntry) -> Void) {
    completion(StaticEntry())
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<StaticEntry>) -> Void) {
    completion(Timeline(entries: [StaticEntry()], policy: .never))
  }
}

/// Opens the app on the SOS screen, handled by HomeWidgetLaunchListener in Dart.
/// The `homeWidget` query item lets the home_widget plugin recognise the URL.
private let sosUrl = URL(string: "mobilezpi://sos?homeWidget")

struct SosWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: "SosWidget", provider: StaticProvider()) { _ in
      VStack(spacing: 4) {
        Text("SOS").font(.system(size: 44, weight: .bold))
        Text("Dotknij, aby wezwać pomoc").font(.subheadline)
      }
      .multilineTextAlignment(.center)
      .padding(12)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .foregroundStyle(.white)
      .containerBackground(error, for: .widget)
      .widgetURL(sosUrl)
    }
    .configurationDisplayName("SOS")
    .description("Otwiera aplikację i wzywa pomoc opiekuna.")
    .supportedFamilies([.systemSmall])
    .contentMarginsDisabled()
  }
}

/// Opens the app on walking navigation home, handled by HomeWidgetLaunchListener in Dart.
private let backHomeUrl = URL(string: "mobilezpi://back-home?homeWidget")

struct BackHomeWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(
      kind: "BackHomeWidget", provider: StoredProvider<Bool>(key: "back_home_has_address")
    ) { entry in
      VStack(spacing: 4) {
        Image(systemName: "house.fill").font(.system(size: 40))
        Text("Wróć do domu").font(.headline)
        if entry.value != true {
          Text("Brak adresu domu").font(.subheadline)
        }
      }
      .multilineTextAlignment(.center)
      .padding(12)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .foregroundStyle(.white)
      .containerBackground(primary, for: .widget)
      .widgetURL(backHomeUrl)
    }
    .configurationDisplayName("Wróć do domu")
    .description("Otwiera w aplikacji nawigację do domu.")
    .supportedFamilies([.systemSmall])
    .contentMarginsDisabled()
  }
}
