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

enum HabitState: String {
    case success = "✅", exceeded = "👏", atLimit = "⚠️", fail = "❌", inProgress = "⏳"
}

@Model
class Habit {
    static let MinNameLength = 3
    static let MaxNameLength = 30
    
    var name: String = ""
    var emoji: String = "🏃‍♂️"
    var type = HabitType.good
    var goal: Int = 1
    var days: [DayOfTheWeek] = [
        DayOfTheWeek.monday,
        DayOfTheWeek.tuesday,
        DayOfTheWeek.wednesday,
        DayOfTheWeek.thursday,
        DayOfTheWeek.friday,
    ]
    var completions: [Date: Int] = [:]
    var order = 1024
    var creationDate: Date = Date.now
    
    init() {
        self.name = ""
        self.emoji = "🏃‍♂️"
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
        self.order = 1024
        self.creationDate = Date.now
    }
    
    private func getDateKey(for date: Date) -> Date {
        return Calendar.current.startOfDay(for: date)
    }
    
    private func canLog(on date: Date) -> Bool {
        return Calendar.current.isDateInToday(date) || date < Date.now
    }
    
    func addCompletion(on date: Date) -> Bool {
        if canLog(on: date) {
            let dateKey = getDateKey(for: date)
            if let count = completions[dateKey] {
                completions[dateKey] = count + 1
            } else {
                completions[dateKey] = 1
            }
            return true
        }
        return false
    }
    
    func deleteCompletion(on date: Date) -> Bool {
        if canLog(on: date) {
            let dateKey = getDateKey(for: date)
            if let count = completions[dateKey] {
                completions[dateKey] = [count - 1, 0].max()
            }
            return true
        }
        return false
    }
    
    func getCompletions(on date: Date) -> Int {
        let dateKey = getDateKey(for: date)
        return completions[dateKey] ?? 0
    }
    
    func getProgress(on date: Date) -> Double {
        let completionsOnDateDouble = Double(getCompletions(on: date))
        if goal == 0 {
            return completionsOnDateDouble
        }
        return completionsOnDateDouble / Double(goal)
    }
    
    func isActive(on date: Date) -> Bool {
        let isOnOrAfterCreation = Calendar.current.isDate(creationDate, inSameDayAs: date) || date > creationDate
        var isOnHabitDay = false
        let weekdayStyle = Date.FormatStyle().weekday(.wide)
        for day in days where day.rawValue == date.formatted(weekdayStyle).lowercased() {
            isOnHabitDay = true
            break
        }
        return isOnOrAfterCreation && isOnHabitDay
    }
    
    func getState(on date: Date) -> HabitState {
        let isToday = Calendar.current.isDateInToday(date)
        let isBeforeToday = !isToday && date < Date.now
        if type == .good {
            if getCompletions(on: date) > goal { return .exceeded }
            if getCompletions(on: date) == goal { return .success }
            if isBeforeToday { return .fail }
        } else {
            if getCompletions(on: date) == goal && goal > 0 && isToday { return .atLimit }
            if getCompletions(on: date) > goal { return .fail }
            if isBeforeToday { return .success }
        }
        return .inProgress
    }
    
    func isValid() -> Bool {
        let validNameLength = name.count >= Habit.MinNameLength && name.count <= Habit.MaxNameLength
        let validEmojiLength = emoji.count == 1
        let validGoal = type == .good && goal > 0 || type == .bad && goal >= 0
        let daySelected = days.count > 0
        return validNameLength && validEmojiLength && validGoal && daySelected
    }
    
    func clone() -> Habit {
        let habit = Habit()
        habit.name = name
        habit.emoji = emoji
        habit.type = type
        habit.goal = goal
        habit.days = days
        habit.completions = completions
        habit.creationDate = creationDate
        return habit
    }
}
