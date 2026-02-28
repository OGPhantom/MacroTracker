//
//  AddMacroViewModel.swift
//  MacroTracker
//
//  Created by Никита Сторчай on 28.02.2026.
//

import Foundation

@Observable
final class AddMacroViewModel {
    var food = ""
    var date = Date()
    var showAlert = false
    var errorMessage = ""

    var isFormValid: Bool {
        food.trimmingCharacters(in: .whitespacesAndNewlines).count > 2
    }

    func submit() async -> MacroResult?  {
        do {
            let result = try await OpenAIAPIClient.shared.sendPrompt(message: food)
            return result
        } catch {
            errorMessage = "Failed to get valid response from AI."
            showAlert = true
            return nil
        }
    }
}
