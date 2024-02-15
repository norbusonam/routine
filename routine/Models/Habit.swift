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
    
    init() {
        self.name = ""
        self.emoji = "🏃‍♀️"
        self.type = RoutineType.positive.rawValue
        self.goal = 1
        self.unit  = "run"
        self.interval = Interval.day.rawValue
        self.days = [
            DaysOfTheWeek.monday.rawValue,
            DaysOfTheWeek.tuesday.rawValue,
            DaysOfTheWeek.wednesday.rawValue,
            DaysOfTheWeek.thursday.rawValue,
            DaysOfTheWeek.friday.rawValue
        ]
    }
}
