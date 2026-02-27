//
//  FormTextField.swift
//  MacroTracker
//
//  Created by Никита Сторчай on 27.02.2026.
//

import SwiftUI

struct FormTextField: View {

    let title: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var contentType: UITextContentType? = nil
    var isSecure: Bool = false

    var body: some View {
        Group {
            if isSecure {
                SecureField(title, text: $text)
            } else {
                TextField(title, text: $text)
            }
        }
        .keyboardType(keyboardType)
        .textContentType(contentType)
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
    }
}
