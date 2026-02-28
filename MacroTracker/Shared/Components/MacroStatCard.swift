//
//  MacroStatCard.swift
//  MacroTracker
//
//  Created by Никита Сторчай on 27.02.2026.
//


import SwiftUI

struct MacroStatCard: View {
    let imageName: String
    let title: String
    let value: Int
    var imageSize: CGFloat = 40

    var body: some View {
        VStack(spacing: 6) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: imageSize)

            Text(title)
                .font(.subheadline)

            Text("\(value) g")
                .font(.headline)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.secondarySystemBackground))
        )
        .frame(maxWidth: .infinity)
    }
}
