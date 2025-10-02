import SwiftUI
import SwiftData

@main
struct WatchMacroTracker_Watch_AppApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Macro.self)
    }
}
