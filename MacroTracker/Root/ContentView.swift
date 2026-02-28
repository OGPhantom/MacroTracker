import SwiftUI

struct ContentView: View {
    var body: some View {
        if FirebaseAuthClient.shared.currentUser != nil {
            MacroView()
        } else {
            SignInView()
        }
    }
}

#Preview {
    ContentView()
}
