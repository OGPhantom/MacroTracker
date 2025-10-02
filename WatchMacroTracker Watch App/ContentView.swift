import SwiftUI

struct ContentView: View {
    @StateObject var watchConnector = WatchToiOSConnector()
    @State var food = ""
    @State var date = Date.now
    @State var isLoading = false
    
    var body: some View {
        ZStack {
            VStack {
                TextField("What did you eat?", text: $food)
                
                DatePicker("When", selection: $date)
                
                Button {
                    sendFoodToOpenAI()
                } label: {
                    Text("Done")
                }
                .disabled(food.count < 3)
            }
            .padding()
            .ignoresSafeArea()
            
            if isLoading {
                Color.primary.opacity(0.7)
                    
                ProgressView()
            }
        }
        .ignoresSafeArea()
    }
    
    func sendFoodToOpenAI() {
        Task {
            do {
                isLoading = true
                let result = try await OpenAIService.shared.sendPromptToChatGPT(message: food)
                isLoading = false
                sendMacroToiOS(result)
            } catch {
                isLoading = false
                print(error.localizedDescription)
            }
        }
    }
    
    func sendMacroToiOS(_ result: MacroResult) {
        let macro = Macro(food: result.food, createdAt: .now, date: date, carbs: result.carbs, fats: result.fats, protein: result.protein)
        watchConnector.sendMacroToiOS(macro: macro)
    }
}

#Preview {
    ContentView()
}
