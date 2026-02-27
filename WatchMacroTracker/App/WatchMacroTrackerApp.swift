import SwiftUI
import SwiftData

@main
struct WatchMacroTracker_Watch_AppApp: App {
    // MARK: - App Initialization
    // Ensures WatchSessionManager is initialized
    // and WatchConnectivity session is activated at launch
    init() {
        _ = WatchSessionManager.shared
    }
    
    // MARK: - App Entry Point
    // Defines the main scene and injects SwiftData model container
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Macro.self)
    }
}
