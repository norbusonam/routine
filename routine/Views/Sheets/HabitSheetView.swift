//
//  HabitSheetView.swift
//  routine
//
//  Created by Norbu Sonam on 2/16/24.
//

import SwiftUI

struct HabitSheetView: View {
    @Binding var habit: Habit
    
    var body: some View {
        VStack {
            Text(habit.emoji)
            Text(habit.name)
            ForEach(habit.days, id: \.rawValue) { day in
                Text(day.rawValue)
            }
            Text("Goal: \(habit.goal)/day")
        }
    }
}

#Preview {
    @State var habit = Habit()
    habit.name = "Running"
    habit.emoji = "🏃‍♂️"
    return HabitSheetView(habit: $habit)
}
