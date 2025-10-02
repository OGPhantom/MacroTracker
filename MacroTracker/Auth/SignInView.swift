import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showRegister = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            Image("main")
                .resizable()
                .scaledToFit()
            Spacer().frame(height: 20)
            
            Spacer().frame(height: 20)
            TextField("Email Address", text: $email)
                .padding()
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                }
            Spacer().frame(height: 20)
            
            SecureField("Password", text: $password)
                .padding()
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                }
            Spacer().frame(height: 20)
            
            Spacer().frame(height: 20) 
            Button("Log In") {
                signIn()
            }
            .bold()
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .foregroundStyle(Color(uiColor: .systemBackground))
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(uiColor: .label))
            }
            
            Button("New User? Sign In") {
                showRegister = true
            }
            .padding()
            .foregroundStyle(Color(uiColor: .label))
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
        .sheet(isPresented: $showRegister) {
            RegisterView()
                .presentationDetents([.fraction(0.5)])
        }
        .alert(isPresented: $showErrorAlert) {
                    Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }
    }
    
    private func signIn() {
            Task {
                do {
                    try await AuthService.shared.signInWithEmail(email: email, password: password)
                } catch {
                    errorMessage = "Invalid email or password"
                    showErrorAlert = true
                }
            }
    }
}

#Preview {
    SignInView()
}
