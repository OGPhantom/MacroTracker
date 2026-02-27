import SwiftUI
import SwiftData
import FirebaseCore

// MARK: - Firebase Setup
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct MacroTrackerApp: App {
    // Bridge UIKit AppDelegate into SwiftUI app
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    init() {
        _ = iOSConnector.shared
    }

    // MARK: - SwiftData Container
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Macro.self)
    }
}
