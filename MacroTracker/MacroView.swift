import SwiftUI
import SwiftData

struct MacroView: View {
    @Environment(\.modelContext) var modelContext
    @StateObject var watchConnector = WatchConnector()
    
    @State var carbs = 0
    @State var fats = 0
    @State var proteins = 0
    
    @Query var macros: [Macro]
    @State var dailyMacros = [DailyMacro]()
    @State var showAddMacro = false
    @State var food = ""
    
    var body: some View {
        NavigationStack {
            ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/) {
                VStack(alignment: .leading) {
                    Text("Today's Marcos")
                        .font(.largeTitle)
                        .padding()
                    
                    MacroHeaderView(carbs: carbs, fats: fats, proteins: proteins)
                        .padding()
                    
                    
                    VStack(alignment: .leading) {
                        Text("Previous Days")
                            .font(.title)
                        
                        ForEach(dailyMacros.indices, id: \.self) { index in
                                if index != 0 {
                                    MacroDayView(macro: dailyMacros[index])
                                }
                            }
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .scrollIndicators(.hidden)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        do {
                            try AuthService.shared.signOut()
                        } catch {
                            print("unable to sign out, call 911")
                        }
                    }) {
                        Image(systemName: "arrow.backward") // Иконка "Exit"
                                        .foregroundColor(.black) // Красный цвет иконки
                                        .imageScale(.large) // Увеличение размера иконки
                    }
                }

            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddMacro = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.black, .black)
                    }
                }
            }
            .sheet(isPresented: $showAddMacro) {
                AddMacroView()
                    .presentationDetents([.fraction(0.4)])
            }
            .onAppear {
                fetchDailyMacros()
                fetchTodaysMacros()
                watchConnector.modelContext = modelContext
            }
            .onChange(of: macros) { _, _ in
                fetchDailyMacros()
                fetchTodaysMacros()
            }
        }
    }
    
    private func fetchDailyMacros() {
        let dates: Set<Date> = Set(macros.map({ Calendar.current.startOfDay(for: $0.date) }))
        
        var dailyMacros = [DailyMacro]()
        for date in dates {
            let filterMacros = macros.filter({ Calendar.current.startOfDay(for: $0.date) == date })
            let carbs: Int = filterMacros.reduce(0, { $0 + $1.carbs })
            let fats: Int = filterMacros.reduce(0, { $0 + $1.fats })
            let protein: Int = filterMacros.reduce(0, { $0 + $1.protein })
            
            let macro = DailyMacro(date: date, carbs: carbs, fats: fats, protein: protein)
            dailyMacros.append(macro)
        }
        
        self.dailyMacros = dailyMacros.sorted(by: { $0.date > $1.date })
    }
    
    private func fetchTodaysMacros() {
        if let firstDateMacro = dailyMacros.first, Calendar.current.startOfDay(for: firstDateMacro.date) == Calendar.current.startOfDay(for: .now) {
            carbs = firstDateMacro.carbs
            fats = firstDateMacro.fats
            proteins = firstDateMacro.protein
        }
    }
}

#Preview {
    MacroView()
}
