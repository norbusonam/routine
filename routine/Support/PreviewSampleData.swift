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
        junkFoodHabit.emoji = "🍔"
        junkFoodHabit.name = "Junk Food"
        junkFoodHabit.type = .bad
        junkFoodHabit.goal = 0
        container.mainContext.insert(junkFoodHabit)
        
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()
