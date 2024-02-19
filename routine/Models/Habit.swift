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

enum HabitState {
    case success, fail, inProgress
}

@Model
class Habit {
    static let MinNameLength = 3
    static let MaxNameLength = 30
    
    var name: String
    var emoji: String
    var type: HabitType
    var goal: Int
    var days: [DayOfTheWeek]
    var completions: [Date: Int]
    var creationDate: Date
    
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
        self.creationDate = Date.now
    }
    
    private func getDateKey(for date: Date) -> Date {
        return Calendar.current.startOfDay(for: date)
    }
    
    func addCompletion(on date: Date) {
        let dateKey = getDateKey(for: date)
        if let count = completions[dateKey] {
            completions[dateKey] = count + 1
        } else {
            completions[dateKey] = 1
        }
    }
    
    func deleteCompletion(on date: Date) {
        let dateKey = getDateKey(for: date)
        if let count = completions[dateKey] {
            completions[dateKey] = [count - 1, 0].max()
        }
    }
    
    func getCompletions(on date: Date) -> Int {
        let dateKey = getDateKey(for: date)
        return completions[dateKey] ?? 0
    }
    
    func getProgress(on date: Date) -> Double {
        return Double(getCompletions(on: date)) / Double(goal)
    }
    
    func shouldShow(on date: Date) -> Bool {
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
        let daysFromToday = Calendar.current.dateComponents([.day], from: Date.now, to: date).day!
        let isBeforeToday = daysFromToday < 0
        if type == .good {
            if getCompletions(on: date) >= goal { return .success }
            if isBeforeToday { return .fail }
        } else {
            if getCompletions(on: date) > goal { return .fail }
            if isBeforeToday { return .success }
        }
        return .inProgress
    }
    
    func isValid() -> Bool {
        return name.count >= Habit.MinNameLength && name.count <= Habit.MaxNameLength && emoji.count == 1 && days.count > 0 && goal >= 0
    }
}
