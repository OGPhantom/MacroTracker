import SwiftUI

struct AddMacroView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel = AddMacroViewModel()

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 20) {

                FormTextField(
                    title: "What did you eat?",
                    text: $viewModel.food
                )

                DatePicker("Date", selection: $viewModel.date)

                PrimaryButton(title: "Done") {
                    Task {
                        let result = await viewModel.submit()
                        if let result {
                            saveMacro(result)
                            dismiss()
                        }
                    }
                }
                .disabled(!viewModel.isFormValid)
            }
            .padding(.top, 24)
            .padding(.horizontal)
            .alert("Oops", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage)
            }

            Button {
                dismiss()
            } label: {
                Image(systemName: "x.circle.fill")
            }
            .font(.title)
            .foregroundStyle(.primary)
        }
    }

    private func saveMacro(_ result: MacroResult) {
        let macro = Macro(
            food: result.food,
            createdAt: .now,
            date: viewModel.date,
            carbs: result.carbs,
            fats: result.fats,
            protein: result.protein
        )
        modelContext.insert(macro)
        try? modelContext.save()
    }
}

#Preview {
    AddMacroView()
}
