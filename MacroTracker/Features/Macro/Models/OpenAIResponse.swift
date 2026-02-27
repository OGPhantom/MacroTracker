//
//  OpenAIResponse.swift
//  MacroTracker
//
//  Created by Никита Сторчай on 27.02.2026.
//

import Foundation

struct OpenAIResponse: Decodable {
    let output: [OpenAIOutput]
}

struct OpenAIOutput: Decodable {
    let content: [OpenAIContentItem]
}

struct OpenAIContentItem: Decodable {
    let type: String
    let text: String?
}
