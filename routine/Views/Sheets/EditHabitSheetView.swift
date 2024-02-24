//
//  EditHabitSheetView.swift
//  routine
//
//  Created by Norbu Sonam on 2/2/24.
//

import SwiftUI
import MCEmojiPicker
import SwiftData

struct EditHabitSheetView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State var isNewHabit: Bool = false
    @State var existingHabit: Habit?
    @State private var habit: Habit = Habit()
    @State private var showEmojiPicker = false
    @State var date = Date.now
    
    @FocusState private var nameFocused: Bool
    
    // new habit flow (isNewHabit is expected to always be true
    init(isNewHabit: Bool) {
        _isNewHabit = State(initialValue: isNewHabit)
    }
    
    // edit flow()
    init(existingHabit: Habit) {
        _existingHabit = State(initialValue: existingHabit)
        _habit = State(initialValue: existingHabit.clone())
    }
    
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
                        isOn: Binding<Bool>(
                            get: { habit.type == .good },
                            set: { habit.type = $0 ? .good : .bad }
                        )
                    )
                    .padding()
                    .foregroundColor(habit.type == .good ? .green : .red)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.primary)
                            .opacity(0.1)
                    }
                    .onChange(of: habit.type) { _, newHabitType in
                        if newHabitType == .good && habit.goal == 0 {
                            withAnimation {
                                habit.goal = 1
                            }
                        }
                        if newHabitType == .bad {
                            withAnimation {
                                habit.goal = 0
                            }
                        }
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
                    .sensoryFeedback(.selection, trigger: habit.days.count)
                    HStack {
                        Button("", systemImage: "minus") {
                            withAnimation {
                                habit.goal = [habit.goal - 1, 0].max()!
                            }
                        }
                        .disabled(
                            habit.type == .good && habit.goal <= 1 ||
                            habit.type == .bad && habit.goal <= 0
                        )
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
                    .sensoryFeedback(.increase, trigger: habit.goal) { oldValue, newValue in
                        return newValue > oldValue
                    }
                    .sensoryFeedback(.decrease, trigger: habit.goal) { oldValue, newValue in
                        return newValue < oldValue
                    }
                    VStack {
                        Toggle(
                            "Reminder",
                            systemImage: "alarm",
                            isOn: $habit.enableReminders
                        )
                        .padding()
                        if habit.enableReminders {
                            DatePicker("At time", selection: $habit.reminderTime, displayedComponents: .hourAndMinute)
                                .padding([.bottom, .horizontal])
                                .transition(.asymmetric(insertion: .push(from: .top), removal: .push(from: .bottom)))
                        }
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.primary)
                            .opacity(0.1)
                    }
                    .animation(.default, value: habit.enableReminders)
                    .transition(AnyTransition.move(edge: .top))
                }
                .padding()
            }
            .navigationTitle(isNewHabit ? "New Habit" : "Edit Habit")
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
                        if isNewHabit {
                            modelContext.insert(habit)
                        } else {
                            if let h = existingHabit {
                                h.name = habit.name
                                h.emoji = habit.emoji
                                h.type = habit.type
                                h.goal = habit.goal
                                h.days = habit.days
                                h.enableReminders = habit.enableReminders
                                h.reminderTime = habit.reminderTime
                            }
                        }
                        dismiss()
                    } label: {
                        Image(systemName: isNewHabit ? "plus.circle.fill" : "checkmark.circle.fill")
                            .imageScale(.large)
                    }
                    .disabled(!habit.isValid)
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
        .foregroundColor(.primary)
        .background {
            Circle()
                .foregroundColor(selectedDays.contains(dayEnumVal) ? .accent : .clear)
        }
    }
}

#Preview {
    ContentView(showNewHabitSheet: true)
        .modelContainer(previewContainer)
}
