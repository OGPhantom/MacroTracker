import SwiftUI

struct SignInView: View {

    @State private var email = ""
    @State private var password = ""
    @State private var showRegister = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 20) {

            Image("main")
                .resizable()
                .scaledToFit()

            FormTextField(
                title: "Email Address",
                text: $email,
                keyboardType: .emailAddress,
                contentType: .emailAddress
            )

            FormTextField(
                title: "Password",
                text: $password,
                contentType: .password,
                isSecure: true
            )

            PrimaryButton(title: "Log In") {
                signIn()
            }
            .disabled(!isFormValid)

            Button("New User? Register") {
                showRegister = true
            }
            .foregroundStyle(.primary)
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
        .sheet(isPresented: $showRegister) {
            RegisterView()
                .presentationDetents([.fraction(0.5)])
        }
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
}


private extension SignInView {
    private var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty
    }

    private func signIn() {
        Task {
            do {
                try await AuthService.shared.signInWithEmail(email: email, password: password)
            } catch {
                await MainActor.run {
                    errorMessage = "Invalid email or password"
                    showErrorAlert = true
                }
            }
        }
    }
}

#Preview {
    SignInView()
}
