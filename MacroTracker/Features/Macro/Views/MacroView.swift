import SwiftUI
import SwiftData

struct MacroView: View {
    @Query private var macros: [Macro]
    @State private var showAddMacro = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    Text("Today's Marcos")
                        .font(.largeTitle)

                    if let todayMacro {
                        MacroHeaderView(
                            carbs: todayMacro.carbs,
                            fats: todayMacro.fats,
                            proteins: todayMacro.protein
                        )
                    } else {
                        MacroHeaderView(carbs: 0, fats: 0, proteins: 0)
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Previous Days")
                            .font(.title)

                        ForEach(dailyMacros.dropFirst()) { macro in
                            MacroDayView(macro: macro)
                        }
                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        try? FirebaseAuthClient.shared.signOut()
                    } label: {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(.primary)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddMacro = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.primary)
                    }
                }
            }
            .sheet(isPresented: $showAddMacro) {
                AddMacroView()
                    .presentationDetents([.fraction(0.4)])
            }
        }
    }
}

private extension MacroView {
    private var dailyMacros: [DailyMacro] {
        let grouped = Dictionary(grouping: macros) {
            Calendar.current.startOfDay(for: $0.date)
        }

        return grouped.map { date, items in
            DailyMacro(
                date: date,
                carbs: items.reduce(0) { $0 + $1.carbs },
                fats: items.reduce(0) { $0 + $1.fats },
                protein: items.reduce(0) { $0 + $1.protein }
            )
        }
        .sorted { $0.date > $1.date }
    }

    private var todayMacro: DailyMacro? {
        let today = Calendar.current.startOfDay(for: .now)
        return dailyMacros.first {
            Calendar.current.startOfDay(for: $0.date) == today
        }
    }
}
#Preview {
    MacroView()
}
