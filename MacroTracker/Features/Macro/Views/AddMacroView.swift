import SwiftUI

struct AddMacroView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var food = ""
    @State private var date = Date()
    @State private var showAlert = false
    @State private var errorMessage = ""

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 20) {

                FormTextField(
                    title: "What did you eat?",
                    text: $food
                )

                DatePicker("Date", selection: $date)

                PrimaryButton(title: "Done") {
                    submit()
                }
                .disabled(!isFormValid)
            }
            .padding(.top, 24)
            .padding(.horizontal)
            .alert("Oops", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
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
}

private extension AddMacroView {
    private var isFormValid: Bool {
        food.trimmingCharacters(in: .whitespacesAndNewlines).count > 2
    }

    private func submit() {
        Task {
            do {
                let result = try await OpenAIAPIClient.shared.sendPrompt(message: food)
                await MainActor.run {
                    saveMacro(result)
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Failed to get valid response from AI."
                    showAlert = true
                }
            }
        }
    }

    private func saveMacro(_ result: MacroResult) {
        let macro = Macro(
            food: result.food,
            createdAt: .now,
            date: date,
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
