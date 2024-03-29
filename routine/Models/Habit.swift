//
//  Routine.swift
//  routine
//
//  Created by Norbu Sonam on 1/14/24.
//

import Foundation
import SwiftData
import UserNotifications

enum HabitType: String, Codable {
    case good, bad
}

enum DayOfTheWeek: String, Codable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    func weekday() -> Int {
        switch self {
        case .monday:
            return 1
        case .tuesday:
            return 2
        case .wednesday:
            return 3
        case .thursday:
            return 4
        case .friday:
            return 5
        case .saturday:
            return 6
        case .sunday:
            return 7
        }
    }
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
    // TODO: update to set
    var days: [DayOfTheWeek] = [
        DayOfTheWeek.monday,
        DayOfTheWeek.tuesday,
        DayOfTheWeek.wednesday,
        DayOfTheWeek.thursday,
        DayOfTheWeek.friday,
    ]
    var completions: [Date: Int] = [:]
    var enableTimeReminder = false
    var reminderTime: Date = Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!
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
        self.enableTimeReminder = false
        self.reminderTime = Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!
        self.order = 1024
        self.creationDate = Date.now
    }
    
    var activeStreak: Int {
        get {
            let stateOnToday = getState(on: Date.now)
            if stateOnToday == .fail {
                return 0
            }
            var streak = stateOnToday == .success || stateOnToday == .exceeded ?  1 : 0
            var day = Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!
            while day > creationDate || Calendar.current.isDate(day, inSameDayAs: creationDate) {
                let isActiveOnDay = isActive(on: day)
                let stateOnDay = getState(on: day)
                if isActiveOnDay && stateOnDay == .fail { break }
                if isActiveOnDay && stateOnDay == .success || stateOnDay == .exceeded { streak += 1 }
                day = Calendar.current.date(byAdding: .day, value: -1, to: day)!
            }
            return streak
        }
    }
    
    var isValid: Bool {
        get {
            let validNameLength = name.count >= Habit.MinNameLength && name.count <= Habit.MaxNameLength
            let validEmojiLength = emoji.count == 1
            let validGoal = type == .good && goal > 0 || type == .bad && goal >= 0
            let daySelected = days.count > 0
            return validNameLength && validEmojiLength && validGoal && daySelected
        }
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
    
    func clone() -> Habit {
        let habit = Habit()
        habit.name = name
        habit.emoji = emoji
        habit.type = type
        habit.goal = goal
        habit.days = days
        habit.completions = completions
        habit.enableTimeReminder = enableTimeReminder
        habit.reminderTime = reminderTime
        habit.order = order
        habit.creationDate = creationDate
        return habit
    }
}

func updateHabitNotifications(_ modelContext: ModelContext) {
    let fetchDescriptor = FetchDescriptor<Habit>()
    let center = UNUserNotificationCenter.current()
    do {
        let habits = try modelContext.fetch(fetchDescriptor)
        center.removeAllPendingNotificationRequests()
        for habit in habits {
            if habit.enableTimeReminder {
                for day in habit.days {
                    if habit.enableTimeReminder {
                        let content = UNMutableNotificationContent()
                        content.title = "\(habit.type == .good ? "🟢" : "🔴") \(habit.name) \(habit.emoji)"
                        content.body = [
                            "Just checking in.",
                            "Time for action.",
                            "Gentle nudge.",
                            "Friendly Reminder.",
                            "Stay on track.",
                            "Keep going!",
                            "Don't forget!",
                            "Consistency is key.",
                            "Make it count.",
                            "One step at a time.",
                            "Today matters.",
                            "Stay focused.",
                            "Keep pushing."
                        ].randomElement()!
                        content.sound = UNNotificationSound.default
                        
                        var dateComponents = DateComponents()
                        dateComponents.weekday = day.weekday()
                        dateComponents.hour = Calendar.current.component(.hour, from: habit.reminderTime)
                        dateComponents.minute = Calendar.current.component(.minute, from: habit.reminderTime)
                        
                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                        
                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                        
                        UNUserNotificationCenter.current().add(request) { error in
                            if let error = error {
                                print("Error scheduling notification: \(error)")
                            }
                        }
                    }
                }
            }
        }
    } catch {
        print("unable to update notifications")
    }
}
