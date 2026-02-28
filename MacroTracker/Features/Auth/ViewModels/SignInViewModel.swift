//
//  SignInViewModel.swift
//  MacroTracker
//
//  Created by Никита Сторчай on 28.02.2026.
//

import Foundation

@Observable
final class SignInViewModel {
    var email = ""
    var password = ""
    var showRegister = false
    var showErrorAlert = false
    var errorMessage = ""

    var isFormValid: Bool {
        !email.isEmpty &&
        !password.isEmpty
    }
    
    func signIn() async -> Bool {
        do {
            try await FirebaseAuthClient.shared.signInWithEmail(email: email, password: password)
            return true
        } catch {
            errorMessage = "Invalid email or password"
            showErrorAlert = true
            return false
        }
    }
}
