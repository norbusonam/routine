//
//  Routine.swift
//  routine
//
//  Created by Norbu Sonam on 1/14/24.
//

import Foundation
import SwiftData

enum HabitType: String, Codable {
    case good, bad
}

enum DayOfTheWeek: String, Codable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

@Model
class Habit {
    var name: String
    var emoji: String
    var type: HabitType
    var goal: Int
    var days: [DayOfTheWeek]
    var completions: [Date: Int]
    var creationDate: Date
    
    init() {
        self.name = ""
        self.emoji = ""
        self.type = .good
        self.goal = 1
        self.days = [
            .monday,
            .tuesday,
            .wednesday,
            .thursday,
            .friday,
        ]
        self.completions = [:]
        self.creationDate = Date.now
    }
    
    private func getDateKey(for date: Date) -> Date {
        return Calendar.current.startOfDay(for: date)
    }
    
    func addCompletion(_ date: Date) {
        let dateKey = getDateKey(for: date)
        if let count = completions[dateKey] {
            completions[dateKey] = count + 1
        } else {
            completions[dateKey] = 1
        }
    }
    
    func deleteCompletion(_ date: Date) {
        let dateKey = getDateKey(for: date)
        if let count = completions[dateKey] {
            completions[dateKey] = [count - 1, 0].max()
        }
    }
    
    func getCompletionsOnDay(_ date: Date) -> Int {
        let dateKey = getDateKey(for: date)
        return completions[dateKey] ?? 0
    }
}
