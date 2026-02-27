import SwiftUI

struct ContentView: View {
    @State private var food = ""
    @State private var date = Date.now
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            VStack(spacing: 12) {
                TextField("What did you eat?", text: $food)

                DatePicker("When", selection: $date)

                Button {
                    submit()
                } label: {
                    Text("Done")
                }
                .disabled(isSubmitDisabled)
            }
            .padding()
            .ignoresSafeArea()

            if isLoading {
                Color.primary.opacity(0.7)
                ProgressView()
            }
        }
        .ignoresSafeArea()
        .alert("Error", isPresented: Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
    }
}


private extension ContentView {
    // MARK: - Validation
    // Disables the button while loading or when the input is too short (after trimming spaces)
    private var isSubmitDisabled: Bool {
        isLoading || food.trimmingCharacters(in: .whitespacesAndNewlines).count < 3
    }

    // MARK: - Submit Food to OpenAI
    // Sends the entered food to OpenAI, waits for macros, then sends the result to iPhone
    private func submit() {
        let message = food.trimmingCharacters(in: .whitespacesAndNewlines)
        let selectedDate = date

        guard message.count >= 3 else { return }

        Task {
            isLoading = true
            errorMessage = nil
            defer { isLoading = false }

            do {
                let result = try await OpenAIService.shared.sendPrompt(message: message)
                sendMacroToiOS(result, date: selectedDate)
                food = ""
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Send Result to iPhone
    // Converts MacroResult into a dictionary and sends it to the iPhone via WatchConnectivity
    private func sendMacroToiOS(_ result: MacroResult, date: Date) {
        let data: [String: Any] = [
            "food": result.food,
            "createdAt": Date.now.timeIntervalSince1970,
            "date": date.timeIntervalSince1970,
            "carbs": result.carbs,
            "fats": result.fats,
            "protein": result.protein
        ]

        WatchSessionManager.shared.send(data)
    }
}
#Preview {
    ContentView()
}
