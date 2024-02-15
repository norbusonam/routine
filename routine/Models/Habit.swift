//
//  Routine.swift
//  routine
//
//  Created by Norbu Sonam on 1/14/24.
//

import Foundation
import SwiftData

enum RoutineType: String, Codable {
    case good, bad
}

enum DayOfTheWeek: String, Codable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

@Model
class Habit {
    var name: String
    var emoji: String
    var type: RoutineType
    var goal: Int
    var days: [DayOfTheWeek]
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
        self.creationDate = Date.now
    }
}
