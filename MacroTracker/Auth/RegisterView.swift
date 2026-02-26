import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var password1 = ""
    @State private var password2 = ""
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            Spacer().frame(height: 20) // Нижний отступ
            TextField("Email Address", text: $email)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding()
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                }
            
            Spacer().frame(height: 20) // Нижний отступ
            SecureField("Password", text: $password1)
                .padding()
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                }
            
            Spacer().frame(height: 20) // Нижний отступ
            SecureField("Verify Password", text: $password2)
                .padding()
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                }
            Spacer().frame(height: 40) // Нижний отступ
            Button("Register") {
                registerNewUser()
            }
            .bold()
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .foregroundStyle(Color(uiColor: .systemBackground))
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(uiColor: .label))
            }
            Spacer().frame(height: 20)
        }
        .padding()
        .alert(isPresented: $showErrorAlert) {
                    Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }
    }
    
    private func registerNewUser() {
        guard isValidEmail(email) else {
            errorMessage = "Invalid email format"
            showErrorAlert = true
            return
        }

        guard isPasswordValid(password1) else {
            errorMessage = "Password should be at least 8 characters long"
            showErrorAlert = true
            return
        }

        guard password1 == password2 else {
            errorMessage = "Passwords do not match"
            showErrorAlert = true
            return
        }

        Task {
            do {
                try await AuthService.shared.registerWithEmail(email: email, password: password1)
                dismiss()
            } catch {
                errorMessage = "Registration failed: \(error.localizedDescription)"
                showErrorAlert = true
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    private func isPasswordValid(_ password: String) -> Bool {
        return password.count >= 8
    }

}

#Preview {
    RegisterView()
}
