import Foundation

// MARK: - OpenAI Errors

enum OpenAIError: Error {
    case invalidResponse
}

// MARK: - OpenAI Service

// Handles network communication with OpenAI API
final class OpenAIAPIClient {

    // MARK: - Shared Instance

    static let shared = OpenAIAPIClient()

    // MARK: - API Key

    // Reads OpenAI key from Info.plist
    static var apiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String else {
            fatalError("OPENAI_API_KEY not found")
        }
        return key
    }

    // MARK: - Request Builder

    // Builds URLRequest with JSON schema for macro response
    private func generateURLRequest(message: String) throws -> URLRequest {
        guard let url = URL(string: "https://api.openai.com/v1/responses") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(OpenAIAPIClient.apiKey)", forHTTPHeaderField: "Authorization")

        let schema: [String: Any] = [
            "type": "object",
            "properties": [
                "food": ["type": "string"],
                "fats": ["type": "integer"],
                "carbs": ["type": "integer"],
                "protein": ["type": "integer"]
            ],
            "required": ["food", "fats", "carbs", "protein"],
            "additionalProperties": false
        ]

        let body: [String: Any] = [
            "model": "gpt-4.1-mini",
            "input": [
                [
                    "role": "system",
                    "content": [
                        ["type": "input_text",
                         "text": "You are a macronutrient expert."]
                    ]
                ],
                [
                    "role": "user",
                    "content": [
                        ["type": "input_text",
                         "text": message]
                    ]
                ]
            ],
            "text": [
                "format": [
                    "type": "json_schema",
                    "name": "macro_schema",
                    "schema": schema
                ]
            ]
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        return request
    }

    // MARK: - Send Prompt

    // Sends request to OpenAI and parses MacroResult
    func sendPrompt(message: String) async throws -> MacroResult {
        let request = try generateURLRequest(message: message)
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse,
              http.statusCode == 200 else {
            throw OpenAIError.invalidResponse
        }

        let decoded = try JSONDecoder().decode(OpenAIResponse.self, from: data)

        guard let jsonString = decoded.output
                .flatMap({ $0.content })
                .first(where: { $0.type == "output_text" })?
                .text,
              let jsonData = jsonString.data(using: .utf8) else {
            throw OpenAIError.invalidResponse
        }

        return try JSONDecoder().decode(MacroResult.self, from: jsonData)
    }
}
