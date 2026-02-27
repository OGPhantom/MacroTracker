//
//  PrimaryButton.swift
//  MacroTracker
//
//  Created by Никита Сторчай on 27.02.2026.
//


import SwiftUI

struct PrimaryButton: View {

    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .bold()
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color(.systemBackground))
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.label))
                )
        }
    }
}
