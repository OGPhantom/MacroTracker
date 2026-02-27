//
//  DailyMacro.swift
//  MacroTracker
//
//  Created by Никита Сторчай on 27.02.2024.
//

import Foundation

struct DailyMacro: Identifiable {
    let id = UUID()
    let date: Date
    let carbs: Int
    let fats: Int
    let protein: Int
}
