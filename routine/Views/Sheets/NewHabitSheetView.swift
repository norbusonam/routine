//
//  NewHabitSheetView.swift
//  routine
//
//  Created by Norbu Sonam on 2/2/24.
//

import SwiftUI
import MCEmojiPicker

enum NewHabitPage: String {
    case type, name, emoji, frequency
}

struct NewHabitSheetView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var habit = Habit()
    @State private var isGoodHabit = true
    @State private var showEmojiPicker = false
    
    @FocusState private var nameFocused: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Button(habit.emoji) {
                            nameFocused = false
                            showEmojiPicker = true
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.primary)
                                .opacity(0.1)
                        }
                        .emojiPicker(
                            isPresented: $showEmojiPicker,
                            selectedEmoji: $habit.emoji
                        )
                        TextField("Name", text: $habit.name)
                            .keyboardType(.asciiCapable)
                            .padding()
                            .focused($nameFocused)
                        
                            .onAppear {
                                nameFocused = true
                            }
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.primary)
                                    .opacity(0.1)
                            }
                            .onChange(of: habit.name) { oldValue, newValue in
                                if newValue.count > Habit.MaxNameLength {
                                    habit.name = oldValue
                                }
                            }
                    }
                    Toggle(
                        habit.type == .good ? "Good habit" : "Bad habit",
                        systemImage: habit.type == .good ? "checkmark.circle" : "x.circle",
                        isOn: $isGoodHabit
                    )
                    .padding()
                    .foregroundColor(habit.type == .good ? .green : .red)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.primary)
                            .opacity(0.1)
                    }
                    // Sync habit.type and isGoodHabit
                    .onChange(of: isGoodHabit) { _, isGoodHabitNew in
                        habit.type = isGoodHabitNew ? .good : .bad
                    }
                    .onChange(of: habit.type) { _, newHabitType in
                        isGoodHabit = newHabitType == .good
                    }
                    HStack {
                        DayButton(dayLabel: "M", dayEnumVal: .monday, selectedDays: $habit.days)
                        Spacer()
                        DayButton(dayLabel: "T", dayEnumVal: .tuesday, selectedDays: $habit.days)
                        Spacer()
                        DayButton(dayLabel: "W", dayEnumVal: .wednesday, selectedDays: $habit.days)
                        Spacer()
                        DayButton(dayLabel: "T", dayEnumVal: .thursday, selectedDays: $habit.days)
                        Spacer()
                        DayButton(dayLabel: "F", dayEnumVal: .friday, selectedDays: $habit.days)
                        Spacer()
                        DayButton(dayLabel: "S", dayEnumVal: .saturday, selectedDays: $habit.days)
                        Spacer()
                        DayButton(dayLabel: "S", dayEnumVal: .sunday, selectedDays: $habit.days)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.primary)
                            .opacity(0.1)
                    }
                    HStack {
                        Button("", systemImage: "minus") {
                            withAnimation {
                                habit.goal = [habit.goal - 1, 0].max()!
                            }
                        }
                        .disabled(habit.goal == 0)
                        Spacer()
                        HStack(spacing: 0) {
                            Text("\(habit.goal)")
                                .transition(.push(from: .top))
                                .id(habit.goal)
                            Text(" / day")
                        }
                        Spacer()
                        Button("", systemImage: "plus") {
                            withAnimation {
                                habit.goal += 1
                            }
                        }
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.primary)
                            .opacity(0.1)
                    }
                }
                .padding()
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.large)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        modelContext.insert(habit)
                        dismiss()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                    .disabled(!habit.isValid())
                }
            }
        }
    }
}

struct DayButton: View {
    let dayLabel: String
    let dayEnumVal: DayOfTheWeek
    
    @Binding var selectedDays: [DayOfTheWeek]
    
    var body: some View {
        Button(dayLabel) {
            if selectedDays.contains(dayEnumVal) {
                selectedDays = selectedDays.filter { day in
                    return day != dayEnumVal
                }
            } else {
                selectedDays.append(dayEnumVal)
            }
        }
        .padding(10)
        .background {
            Circle()
                .foregroundColor(selectedDays.contains(dayEnumVal) ? .accent : .clear)
        }
        .foregroundColor(.primary)
    }
}

#Preview {
    ContentView(showNewHabitSheet: true)
}
