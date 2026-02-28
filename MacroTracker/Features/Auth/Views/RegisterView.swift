import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = RegisterViewModel()

    var body: some View {
        VStack(spacing: 20) {
            FormTextField(
                title: "Email Address",
                text: $viewModel.email,
                keyboardType: .emailAddress,
                contentType: .emailAddress
            )

            FormTextField(
                title: "Password",
                text: $viewModel.password,
                contentType: .password,
                isSecure: true
            )

            FormTextField(
                title: "Confirm Password",
                text: $viewModel.confirmPassword,
                contentType: .password,
                isSecure: true
            )

            PrimaryButton(title: "Register") {
                Task {
                    let success = await viewModel.register()
                    if success {
                        dismiss()
                    }
                }
            }
            .disabled(!viewModel.isFormValid)
        }
        .padding()
        .alert("Error", isPresented: $viewModel.showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

#Preview {
    RegisterView()
}
