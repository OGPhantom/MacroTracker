import SwiftUI

struct MacroHeaderView: View {
    var carbs: Int
    var fats: Int
    var proteins: Int

    var body: some View {
        HStack {
            Spacer()
            MacroStatCard(imageName: "carbs",
                          title: "Carbs",
                          value: carbs,
                          imageSize: 60)

            Spacer()
            MacroStatCard(imageName: "fats",
                          title: "Fats",
                          value: fats,
                          imageSize: 60)

            Spacer()
            MacroStatCard(imageName: "proteins",
                          title: "Protein",
                          value: proteins,
                          imageSize: 60)

            Spacer()
        }
    }
}

#Preview {
    MacroHeaderView(carbs: 10, fats: 10, proteins: 10)
}
