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
    
    func deleteTask() {
        modelContext.delete(habit)
        dismiss()
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: deleteTask) {
                    Image(systemName: "trash.circle")
                        .imageScale(.large)
                }
                .foregroundColor(.red)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                }
            }
            Spacer()
            VStack {
                Text(habit.emoji)
                Text(habit.name)
                ForEach(habit.days, id: \.rawValue) { day in
                    Text(day.rawValue)
                }
                Text("Goal: \(habit.goal)/day")
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    @State var habit = Habit()
    habit.name = "Running"
    habit.emoji = "🏃‍♂️"
    return HabitSheetView(habit: $habit)
}
