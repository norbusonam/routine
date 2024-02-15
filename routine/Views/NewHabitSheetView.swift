//
//  NewHabitSheetView.swift
//  routine
//
//  Created by Norbu Sonam on 2/2/24.
//

import SwiftUI

enum NewHabitPage: Hashable {
    case type, name, emoji, frequency
}

struct NewHabitSheetView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State var habit = Habit()
    @State var page = NewHabitPage.type
    
    func onDone() {
        modelContext.insert(habit)
        dismiss()
    }
    
    func changePage(_ nextPage: NewHabitPage) {
        page = nextPage
    }
    
    var body: some View {
        VStack() {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                }
                .padding()
            }
            Spacer()
            TabView(selection: $page) {
                // +------+
                // | type |
                // +------+
                VStack(spacing: 32) {
                    Text("Is this a good habit you want to grow or a bad habit you want to stop?")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    HStack {
                        Spacer()
                        Button("🙂") {
                            habit.type = .good
                            changePage(.name)
                        }
                        Spacer()
                        Button("😓") {
                            habit.type = .bad
                            changePage(.name)
                        }
                        Spacer()
                    }
                }
                .padding()
                .tag(NewHabitPage.type)
                // +------+
                // | name |
                // +------+
                VStack(spacing: 32) {
                    Text("What is the habit?")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    TextField(habit.type == .good ? "Run" : "Smoking", text: $habit.name)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .onSubmit {
                            // TODO: validate name
                            page = .emoji
                        }
                }
                .padding()
                .tag(NewHabitPage.name)
                // +-------+
                // | emoji |
                // +-------+
                VStack(spacing: 32) {
                    Text("Select an emoji for your habit")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    TextField(habit.type == .good ? "🏃‍♂️" : "🚬", text: $habit.emoji)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .onSubmit {
                            // TODO: validate emoji
                            changePage(.frequency)
                        }
                }
                .padding()
                .tag(NewHabitPage.emoji)
                // +-----------+
                // | frequency |
                // +-----------+
                VStack(spacing: 32) {
                    Text("How often do you want do this habit?")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    HStack {
                        DayButton(dayLabel: "M", dayEnumVal: .monday, daysList: $habit.days)
                        Spacer()
                        DayButton(dayLabel: "T", dayEnumVal: .tuesday, daysList: $habit.days)
                        Spacer()
                        DayButton(dayLabel: "W", dayEnumVal: .wednesday, daysList: $habit.days)
                        Spacer()
                        DayButton(dayLabel: "T", dayEnumVal: .thursday, daysList: $habit.days)
                        Spacer()
                        DayButton(dayLabel: "F", dayEnumVal: .friday, daysList: $habit.days)
                        Spacer()
                        DayButton(dayLabel: "S", dayEnumVal: .saturday, daysList: $habit.days)
                        Spacer()
                        DayButton(dayLabel: "S", dayEnumVal: .sunday, daysList: $habit.days)
                    }
                    HStack {
                        Button("Down") {
                            habit.goal = [habit.goal - 1, 0].max()!
                        }
                        Spacer()
                        Text("\(habit.goal) \(habit.goal == 1 ? "time" : "times") per day")
                        Spacer()
                        Button("Up") {
                            habit.goal += 1
                        }
                    }
                    Button("Done", action: onDone)
                }
                .padding()
                .tag(NewHabitPage.frequency)
            }
        }
    }
}

struct DayButton: View {
    let dayLabel: String
    let dayEnumVal: DayOfTheWeek
    
    @Binding var daysList: [DayOfTheWeek]
    
    var body: some View {
        Button(dayLabel) {
            if (daysList.contains(dayEnumVal)) {
                daysList = daysList.filter { day in
                    return day != dayEnumVal
                }
            } else {
                daysList.append(dayEnumVal)
            }
        }
        .foregroundColor(daysList.contains(dayEnumVal) ? .accent : .primary)
    }
}

#Preview {
    AuthenticatedView(showNewHabitSheet: true)
}
