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
    
    @Binding var habit: Habit
    @Binding var date: Date
    
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
                    .stroke(.accent, lineWidth: 20)
                    .opacity(0.4)
                Circle()
                    .trim(
                        from: 0,
                        to: habit.getProgress(on: date)
                    )
                    .stroke(.accent, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                VStack(spacing: 10) {
                    switch habit.getState(on: date) {
                    case .success:
                        Text("✅")
                            .font(.largeTitle)
                            .transition(.scale)
                    case .fail:
                        Text("❌")
                            .font(.largeTitle)
                            .transition(.scale)
                    case .inProgress:
                        Text(habit.emoji)
                            .font(.largeTitle)
                            .transition(.scale)
                    }
                    Text(habit.name)
                        .font(.headline)
                    HStack(spacing: 0) {
                        Text("\(habit.getCompletions(on: date))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .transition(.scale)
                            .id(habit.getCompletions(on: date))
                        Text(" / \(habit.goal)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.75)
            Spacer()
            HStack {
                Spacer()
                Button("", systemImage: "minus") {
                    withAnimation {
                        habit.deleteCompletion(on: date)
                    }
                }
                .font(.title)
                .disabled(habit.getCompletions(on: date) == 0)
                Spacer()
                Button("", systemImage: "plus") {
                    withAnimation {
                        habit.addCompletion(on: date)
                    }
                }
                .font(.title)
                Spacer()
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    @State var habit = Habit()
    @State var date = Date.now
    habit.name = "Running"
    habit.emoji = "🏃‍♂️"
    return HabitSheetView(habit: $habit, date: $date)
}
