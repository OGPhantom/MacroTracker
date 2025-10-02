import SwiftUI

struct AddMacroView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var food = ""
    @State private var date = Date()
    @State private var showAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 20) {
                
                TextField("What did you eat?", text: $food)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke()
                    )
                
                DatePicker("Date", selection: $date)
                
                Button {
                    if food.count > 2 {
                        sendItemToChatGPT()
                    } else {
                        errorMessage = "Input is too small"
                        showAlert = true;
                    }
                } label: {
                    Text("Done")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color(uiColor: .systemBackground))
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(uiColor: .label))
                        )
                }
            }
            .padding(.top, 24)
            .padding(.horizontal)
            .alert("Oops", isPresented: $showAlert) {
                Text("Ok")
            } message: {
                Text(errorMessage)
            }
            
            Button("", systemImage: "x.circle.fill") {
                dismiss()
            }
            .font(.title)
            .foregroundStyle(.primary)
        }
    }
    
    private func sendItemToChatGPT() {
        Task {
            do {
                let result = try await OpenAIService.shared.sendPromptToChatGPT(message: food)
                saveMacro(result)
                dismiss()
            } catch {
                if let openAIError = error as? OpenAIError {
                    switch openAIError {
                    case .noFunctionCall:
                        errorMessage = "We were unable able to verify the food item. Please make sure you enter a valid food item and try again."
                        showAlert = true
                    case .unableToConvertStringIntoData:
                        print(error.localizedDescription)
                    }
                } else {
                    errorMessage = "sth wrong with me"
                    showAlert = true
                    print(error.localizedDescription) //here
                }
            }
        }
    }
    
    private func saveMacro(_ result: MacroResult) {
        let macro = Macro(food: result.food, createdAt: .now, date: date, carbs: result.carbs, fats: result.fats, protein: result.protein)
        modelContext.insert(macro)
    }
}

#Preview {
    AddMacroView()
}
