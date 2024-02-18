//
//  HabitSheetView.swift
//  routine
//
//  Created by Norbu Sonam on 2/16/24.
//

import SwiftUI

struct HabitSheetView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var habit: Habit
    var date: Date
    
    func deleteTask() {
        modelContext.delete(habit)
        dismiss()
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                }
                Spacer()
                Text(date.formatted(.dateTime.day().month().year()))
                    .font(.headline)
                Spacer()
                Menu {
                    Button(role: .destructive, action: deleteTask) {
                        Text("Delete")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.large)
                }
            }
            Spacer()
            ZStack {
                Circle()
                    .stroke(.accent, lineWidth: 24)
                    .opacity(0.2)
                Circle()
                    .trim(from: 0, to: CGFloat(habit.getCompletionsOnDay(date)) / CGFloat(habit.goal))
                    .stroke(.accent, style: StrokeStyle(lineWidth: 24, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .shadow(color: .black, radius: 5, x: 5, y: 5)
                VStack {
                    Text(habit.emoji)
                        .font(.largeTitle)
                    Text(habit.name)
                        .font(.headline)
                    HStack(spacing: 0) {
                        Text("\(habit.getCompletionsOnDay(date))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .transition(.scale)
                            .id(habit.getCompletionsOnDay(date))
                        Text(" / \(habit.goal)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .animation(.easeInOut, value: habit.getCompletionsOnDay(date))
            .frame(width: UIScreen.main.bounds.width * 0.75)
            Spacer()
            HStack {
                Spacer()
                Button("", systemImage: "minus") {
                    habit.deleteCompletion(date)
                }
                Spacer()
                Button("", systemImage: "plus") {
                    habit.addCompletion(date)
                }
                Spacer()
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    var habit = Habit()
    habit.name = "Running"
    habit.emoji = "🏃‍♂️"
    return HabitSheetView(habit: habit, date: Date.now)
}
