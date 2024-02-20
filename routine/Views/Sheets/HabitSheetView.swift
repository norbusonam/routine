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
    
    @State private var showEditSheet = false

    @Binding var habit: Habit
    @Binding var date: Date
    
    func deleteTask() {
        modelContext.delete(habit)
        dismiss()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                ZStack {
                    Circle()
                        .stroke(.accent, lineWidth: 20)
                        .opacity(0.4)
                    Circle()
                        .trim(
                            from: 0,
                            to: [habit.getProgress(on: date), 0.00001].max()!
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
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
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
            .navigationTitle(date.formatted(.dateTime.day().month().year()))
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
                    Menu {
                        Button {
                            showEditSheet = true
                        } label: {
                            Text("Edit")
                        }
                        Button(role: .destructive, action: deleteTask) {
                            Text("Delete")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $showEditSheet) {
                EditHabitSheetView(existingHabit: habit)
            }
        }
    }
}

#Preview {
    @State var habit = Habit()
    @State var date = Date.now
    habit.name = "Running"
    habit.emoji = "🏃‍♂️"
    return HabitSheetView(habit: $habit, date: $date)
}
