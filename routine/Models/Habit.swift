//
//  Routine.swift
//  routine
//
//  Created by Norbu Sonam on 1/14/24.
//

import SwiftData

enum RoutineType: String {
    case positive, negative
}

enum Interval: String {
    case day, week, month, year
}

enum DaysOfTheWeek: String {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

@Model
class Habit {
    var name: String
    var emoji: String
    var type: String
    var goal: Int
    var unit: String
    var interval: String
    var days: [String]
    
    init(name: String, emoji: String, type: RoutineType, goal: Int, unit: String, interval: Interval, days: [DaysOfTheWeek]) {
        self.name = name
        self.emoji = emoji
        self.type = type.rawValue
        self.goal = goal
        self.unit = unit
        self.interval = interval.rawValue
        self.days = days.map(\.rawValue)
    }
}
