import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var email = ""
    @State private var password1 = ""
    @State private var password2 = ""
    @State private var showErrorAlert = false
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 20) {

            FormTextField(
                title: "Email Address",
                text: $email,
                keyboardType: .emailAddress,
                contentType: .emailAddress
            )

            FormTextField(
                title: "Password",
                text: $password1,
                contentType: .password,
                isSecure: true
            )

            FormTextField(
                title: "Password",
                text: $password2,
                contentType: .password,
                isSecure: true
            )

            PrimaryButton(title: "Register") {
                registerNewUser()
            }
            .disabled(!isFormValid)
        }
        .padding()
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
}


private extension RegisterView {
    private var isFormValid: Bool {
        !email.isEmpty &&
        !password1.isEmpty &&
        !password2.isEmpty
    }

    private func registerNewUser() {
        guard password1 == password2 else {
            errorMessage = "Passwords do not match"
            showErrorAlert = true
            return
        }

        guard password1.count >= 8 else {
            errorMessage = "Password must be at least 8 characters"
            showErrorAlert = true
            return
        }

        Task {
            do {
                try await AuthService.shared.registerWithEmail(email: email, password: password1)
                dismiss()
            } catch {
                await MainActor.run {
                    errorMessage = "Registration failed"
                    showErrorAlert = true
                }
            }
        }
    }
}

#Preview {
    RegisterView()
}
