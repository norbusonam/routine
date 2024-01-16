//
//  Routine.swift
//  routine
//
//  Created by Norbu Sonam on 1/14/24.
//

import SwiftData

enum RoutineType {
    case positive, negative
}

enum Interval {
    case day, week, month, year
}

enum DaysOfTheWeek {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

//@Model
//class Routine {
//    var name: String
//    var emoji: Character
//    var type: RoutineType
//    var goal: Int
//    var unit: String
//    var interval: Interval
//    var days: [DaysOfTheWeek]
//    
//    init() { }
//}
