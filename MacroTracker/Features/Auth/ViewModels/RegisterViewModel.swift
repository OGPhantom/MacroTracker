//
//  RegisterViewModel.swift
//  MacroTracker
//
//  Created by Никита Сторчай on 28.02.2026.
//

import Foundation

@Observable
final class RegisterViewModel {
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""

    var showErrorAlert: Bool = false
    var errorMessage: String = ""

    var isFormValid: Bool {
        !email.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty
    }

    func register() async -> Bool {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            showErrorAlert = true
            return false
        }

        guard password.count >= 8 else {
            errorMessage = "Password must be at least 8 characters"
            showErrorAlert = true
            return false
        }

        do {
            try await FirebaseAuthClient.shared.registerWithEmail(email: email, password: password)
            return true
        } catch {
            errorMessage = "Registration failed"
            showErrorAlert = true
            return false
        }
    }
}
