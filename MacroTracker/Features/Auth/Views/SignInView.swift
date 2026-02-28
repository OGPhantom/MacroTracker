import SwiftUI

struct SignInView: View {
    @State private var viewModel = SignInViewModel()
    var body: some View {
        VStack(spacing: 20) {

            Image("main")
                .resizable()
                .scaledToFit()

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

            PrimaryButton(title: "Log In") {
                Task {
                    _ = await viewModel.signIn()
                }
            }
            .disabled(!viewModel.isFormValid)

            Button("New User? Register") {
                viewModel.showRegister = true
            }
            .foregroundStyle(.primary)
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
        .sheet(isPresented: $viewModel.showRegister) {
            RegisterView()
                .presentationDetents([.fraction(0.5)])
        }
        .alert("Error", isPresented: $viewModel.showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

#Preview {
    SignInView()
}
