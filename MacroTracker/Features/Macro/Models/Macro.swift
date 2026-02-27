//
//  Macro.swift
//  MacroTracker
//
//  Created by Никита Сторчай on 27.02.2024.
//

import Foundation
import SwiftData

@Model
final class Macro {
    var food: String
    var createdAt: Date
    var date: Date
    var carbs: Int
    var fats: Int
    var protein: Int

    init(food: String, createdAt: Date, date: Date, carbs: Int, fats: Int, protein: Int) {
        self.food = food
        self.createdAt = createdAt
        self.date = date
        self.carbs = carbs
        self.fats = fats
        self.protein = protein
    }
}
