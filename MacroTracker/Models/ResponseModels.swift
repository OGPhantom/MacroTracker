import Foundation

struct GPTResponse: Decodable {
    let choices: [GPTCompletion]
}

struct GPTCompletion: Decodable {
    let message: GPTResponseMessage
    
}

struct GPTResponseMessage: Decodable {
    let functionCall: GPTFunctionCall?
    
    enum CodingKeys: String, CodingKey {
        case functionCall = "function_call"
    }
}

struct GPTFunctionCall: Decodable {
    let name: String
    let arguments: String
}

struct MacroResult: Decodable {
    let food: String
    let fats: Int
    let protein: Int
    let carbs: Int
}
