//
//  NewHabitSheetView.swift
//  routine
//
//  Created by Norbu Sonam on 2/2/24.
//

import SwiftUI

extension Character {
    var isEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
                0x1F300...0x1F5FF,  // Misc Symbols and Pictographs
                0x1F680...0x1F6FF,  // Transport and Map
                0x1F1E6...0x1F1FF,  // Regional country flags
                0x2600...0x26FF,    // Misc symbols
                0x2700...0x27BF,    // Dingbats
                0xFE00...0xFE0F,    // Variation Selectors
                0x1F900...0x1F9FF,  // Supplemental Symbols and Pictographs
                127000...127600,    // Various asian characters
                65024...65039,      // Variation selector
                9100...9300,        // Misc items
                8400...8447:        // Combining Diacritical Marks for Symbols
                return true
            default:
                continue
            }
        }
        return false
    }
}

enum NewHabitPage: String {
    case type, name, emoji, frequency
}

struct NewHabitSheetView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var habit = Habit()
    @State private var page = NewHabitPage.type
    
    @FocusState private var nameFocused: Bool
    @FocusState private var emojiFocused: Bool
    
    func changePage(_ newPage: NewHabitPage) {
        withAnimation {
            page = newPage
        }
        if newPage == .name {
            emojiFocused = false
            nameFocused = true
        } else if newPage == .emoji {
            nameFocused = false
            emojiFocused = true
        } else {
            nameFocused = false
            emojiFocused = false
        }
    }
    
    func onBack() {
        if page == .frequency {
            changePage(.emoji)
        } else if (page == .emoji) {
            changePage(.name)
        } else if (page == .name) {
            changePage(.type)
        }
    }
    
    func onDone() {
        modelContext.insert(habit)
        dismiss()
    }
    
    var body: some View {
        VStack() {
            HStack {
                if page != .type {
                    Button(action: onBack) {
                        Image(systemName: "arrow.left.circle.fill")
                            .imageScale(.large)
                    }
                    .transition(.scale)
                }
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
                        .font(.title)
                        .multilineTextAlignment(.center)
                    HStack {
                        Spacer()
                        Button {
                            habit.type = .good
                            changePage(.name)
                        } label: {
                            VStack {
                                Text("🙂")
                                    .font(.largeTitle)
                                Text("Good habit")
                                    .foregroundColor(.green)
                            }
                        }
                        Spacer()
                        Button {
                            habit.type = .bad
                            changePage(.name)
                        } label: {
                            VStack {
                                Text("😞")
                                    .font(.largeTitle)
                                Text("Bad habit")
                                    .foregroundColor(.red)
                            }
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
                        .font(.title)
                        .multilineTextAlignment(.center)
                    TextField("", text: $habit.name)
                        .frame(height: 48)
                        .foregroundColor(.accent)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .focused($nameFocused)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.accent, lineWidth: 2)
                        )
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
                        .font(.title)
                        .multilineTextAlignment(.center)
                    TextField("", text: $habit.emoji)
                        .frame(width: 48, height: 48)
                        .accentColor(habit.emoji.isEmpty ? .accent : .clear)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .focused($emojiFocused)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.accent, lineWidth: 2)
                        )
                        .onSubmit {
                            // TODO: validate emoji
                            changePage(.frequency)
                        }
                        .onChange(of: habit.emoji) { _, newEmoji in
                            if newEmoji.count > 0 && newEmoji.last!.isEmoji {
                                habit.emoji = "\(newEmoji.last!)"
                            } else {
                                habit.emoji = ""
                            }
                        }
                }
                .transition(.scale)
            } else if page == .frequency {
                // +-----------+
                // | frequency |
                // +-----------+
                VStack(spacing: 32) {
                    Text("Habit frequency goal")
                        .font(.title)
                        .multilineTextAlignment(.center)
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
                    HStack {
                        Button("", systemImage: "arrow.down") {
                            habit.goal = [habit.goal - 1, 1].max()!
                        }
                        .disabled(habit.goal == 1)
                        Spacer()
                        Text("\(habit.goal) \(habit.goal == 1 ? "time" : "times") per day")
                        Spacer()
                        Button("", systemImage: "arrow.up") {
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
    
    @Binding var selectedDays: [DayOfTheWeek]
    
    var body: some View {
        Button(dayLabel) {
            if (selectedDays.contains(dayEnumVal)) {
                if selectedDays.count > 1 {
                    selectedDays = selectedDays.filter { day in
                        return day != dayEnumVal
                    }
                }
            } else {
                selectedDays.append(dayEnumVal)
            }
        }
        .foregroundColor(selectedDays.contains(dayEnumVal) ? .accent : .primary)
    }
}

#Preview {
    ContentView(showNewHabitSheet: true)
}
