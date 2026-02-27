import SwiftUI

struct MacroDayView: View {
    @State var macro: DailyMacro

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(macro.date.monthAndDay)
                    .font(.headline)

                Text(macro.date.year)
                    .font(.subheadline)
            }

            Spacer()

            HStack {
                MacroStatCard(imageName: "carbs",
                              title: "Carbs",
                              value: macro.carbs)

                MacroStatCard(imageName: "fats",
                              title: "Fats",
                              value: macro.fats)

                MacroStatCard(imageName: "proteins",
                              title: "Protein",
                              value: macro.protein)
            }
            .frame(maxWidth: .infinity)

            Spacer()
        }
    }
}
