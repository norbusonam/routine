//
//  PreviewSampleData.swift
//  routine
//
//  Created by Norbu Sonam on 2/22/24.
//

import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: Habit.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        
        let runningHabit = Habit()
        runningHabit.emoji = "🏃‍♂️"
        runningHabit.name = "Running"
        runningHabit.type = .good
        runningHabit.goal = 1
        container.mainContext.insert(runningHabit)
        
        
        let junkFoodHabit = Habit()
        runningHabit.emoji = "🍔"
        runningHabit.name = "Junk Food"
        runningHabit.type = .bad
        runningHabit.goal = 0
        container.mainContext.insert(junkFoodHabit)
        
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()
