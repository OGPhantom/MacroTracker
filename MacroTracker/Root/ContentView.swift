import SwiftUI

struct ContentView: View {
    
    var body: some View {
        if AuthService.shared.currentUser != nil {
            MacroView()
        } else {
            SignInView()
        }
    }
}

#Preview {
    ContentView()
}
