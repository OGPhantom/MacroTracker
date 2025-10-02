import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
}

enum OpenAIError: Error {
    case noFunctionCall
    case unableToConvertStringIntoData
}

class OpenAIService {
    
    static let shared = OpenAIService()
    
    private init () { }
    
    private func generateURLRequest(httpMethod: HTTPMethod, message: String) throws -> URLRequest {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: url)
        
        // Method
        urlRequest.httpMethod = httpMethod.rawValue
        
        // Header
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(Secrets.apiKey)", forHTTPHeaderField: "Authorization")
        
        // Body
        let systemMessage = GPTMessage(role: "system", content: "You are a macronutrient expert.")
        let userMessage = GPTMessage(role: "user", content: message)
        
        let food = GPTFunctionProperty(type: "string", description: "The food item e.g. apple, hamburger")
        let fats = GPTFunctionProperty(type: "integer", description: "The amount of fats in grams of the given food item")
        let carbs = GPTFunctionProperty(type: "integer", description: "The amount of carbohydrates in grams of the given food item")
        let protein = GPTFunctionProperty(type: "integer", description: "The amount of fats in protein of the given food item")
        let params: [String: GPTFunctionProperty] = [
            "food": food,
            "fats": fats,
            "carbs": carbs,
            "protein": protein
        ]
        
        let functionParams = GPTFunctionParam(type: "object", properties: params, required: ["food", "fats", "carbs", "protein"])
        let function = GPTFunction(name: "get_macronutrients", description: "Get the macronutrients for a given food.", parameters: functionParams)
        let payload = GPTChatPayload(model: "gpt-3.5-turbo-0613", messages: [systemMessage, userMessage], functions: [function])
        
        let jsonData = try JSONEncoder().encode(payload)
        
        urlRequest.httpBody = jsonData
        
        return urlRequest
    }
    
    func sendPromptToChatGPT(message: String) async throws -> MacroResult {
        let urlRequest = try generateURLRequest(httpMethod: .post, message: message)
        print("Request: \(urlRequest)")
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        print("Response: \(response)")

        let result = try JSONDecoder().decode(GPTResponse.self, from: data)

        guard let functionCall = result.choices[0].message.functionCall else {
            throw OpenAIError.noFunctionCall
        }
        
        guard let argData = functionCall.arguments.data(using: .utf8) else {
            throw OpenAIError.unableToConvertStringIntoData
        }
        let macro = try JSONDecoder().decode(MacroResult.self, from: argData)
        return macro
    }
    
}

