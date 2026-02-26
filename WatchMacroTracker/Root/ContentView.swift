import SwiftUI

struct ContentView: View {
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
            isLoading = true
            defer { isLoading = false }

            do {
                let result = try await OpenAIService.shared.sendPrompt(message: food)
                sendMacroToiOS(result)
                food = ""
            } catch {
                isLoading = false
                print(error.localizedDescription)
            }
        }
    }
    
    func sendMacroToiOS(_ result: MacroResult) {
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
