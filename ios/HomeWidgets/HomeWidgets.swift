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

/// Values saved from Dart with `HomeWidget.saveWidgetData` (`HomeWidgetKeys`).
struct StoredEntry: TimelineEntry {
  let date = Date()
  var sosStatus: String? = nil
  var signedIn = true
  var hasHome = false
}

struct StoredProvider: TimelineProvider {
  func placeholder(in context: Context) -> StoredEntry {
    StoredEntry()
  }

  func getSnapshot(in context: Context, completion: @escaping (StoredEntry) -> Void) {
    let defaults = UserDefaults(suiteName: homeWidgetsAppGroup)
    completion(
      StoredEntry(
        sosStatus: defaults?.string(forKey: "sos_status"),
        signedIn: defaults?.object(forKey: "signed_in") as? Bool ?? true,
        hasHome: defaults?.bool(forKey: "has_home") ?? false
      ))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<StoredEntry>) -> Void) {
    getSnapshot(in: context) { completion(Timeline(entries: [$0], policy: .never)) }
  }
}

struct SosWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: "SosWidget", provider: StoredProvider()) { entry in
      SosWidgetView(entry: entry)
        .foregroundStyle(.white)
        .containerBackground(error, for: .widget)
    }
    .configurationDisplayName("SOS")
    .description("Wzywa pomoc opiekuna jednym dotknięciem.")
    .supportedFamilies([.systemSmall])
    .contentMarginsDisabled()
  }
}

/// Signed in, a tap sends SOS in the background. Signed out, the widget has
/// no button, so a tap opens the app on the login screen.
struct SosWidgetView: View {
  let entry: StoredEntry

  var body: some View {
    if entry.signedIn {
      Button(intent: SosIntent()) { content }
        .buttonStyle(.plain)
    } else {
      content
    }
  }

  private var content: some View {
    VStack(spacing: 4) {
      Text("SOS").font(.system(size: 44, weight: .bold))
      Text(entry.sosStatus ?? "Dotknij, aby wezwać pomoc")
        .font(.subheadline)
        .multilineTextAlignment(.center)
    }
    .padding(12)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .contentShape(Rectangle())
  }
}

struct BackHomeWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: "BackHomeWidget", provider: StoredProvider()) { entry in
      VStack(spacing: 4) {
        Image(systemName: "house.fill").font(.system(size: 40))
        Text("Wróć do domu").font(.headline)
        if !entry.hasHome {
          Text("Brak adresu domu").font(.subheadline)
        }
      }
      .multilineTextAlignment(.center)
      .padding(12)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .foregroundStyle(.white)
      .containerBackground(primary, for: .widget)
      // `backHomeWidgetHost` in Dart opens the walk home in the app.
      .widgetURL(URL(string: "zpi://back-home?homeWidget"))
    }
    .configurationDisplayName("Wróć do domu")
    .description("Otwiera w aplikacji nawigację do domu.")
    .supportedFamilies([.systemSmall])
    .contentMarginsDisabled()
  }
}
