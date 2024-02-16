//
//  NewHabitSheetView.swift
//  routine
//
//  Created by Norbu Sonam on 2/2/24.
//

import SwiftUI

enum NewHabitPage: String {
    case type, name, emoji, frequency
}

struct NewHabitSheetView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State var habit = Habit()
    @State var page = NewHabitPage.type
    
    @FocusState var nameFocused: Bool
    @FocusState var emojiFocused: Bool
    
    func changePage(_ newPage: NewHabitPage) {
        withAnimation {
            page = newPage
        }
        if newPage == .name {
            nameFocused = true
        } else if newPage == .emoji {
            emojiFocused = true
        }
    }
    
    func onDone() {
        modelContext.insert(habit)
        dismiss()
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
            }
            Spacer()
            if page == .type {
                // +------+
                // | type |
                // +------+
                VStack(spacing: 32) {
                    Text("Habit type")
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
                .transition(.scale)
            } else if page == .name {
                // +------+
                // | name |
                // +------+
                VStack(spacing: 32) {
                    Text("Habit title")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    TextField("", text: $habit.name)
                        .foregroundColor(.accent)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .focused($nameFocused)
                        .onSubmit {
                            changePage(.emoji)
                        }
                }
                .transition(.scale)
            } else if page == .emoji {
                // +-------+
                // | emoji |
                // +-------+
                VStack(spacing: 32) {
                    Text("Habit emoji")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    TextField("", text: $habit.emoji)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .focused($emojiFocused)
                        .onSubmit {
                            // TODO: validate emoji
                            changePage(.frequency)
                        }
                }
                .transition(.scale)
            } else if page == .frequency {
                // +-----------+
                // | frequency |
                // +-----------+
                VStack(spacing: 32) {
                    Text("Habit frequency goal")
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
                .transition(.scale)
            }
            Spacer()
        }
        .padding()
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
