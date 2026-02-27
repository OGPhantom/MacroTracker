//
//  MacroResult.swift
//  MacroTracker
//
//  Created by Никита Сторчай on 27.02.2026.
//

import Foundation

struct MacroResult: Decodable {
    let food: String
    let fats: Int
    let protein: Int
    let carbs: Int
}
