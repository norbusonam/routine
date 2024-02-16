//
//  routineApp.swift
//  routine
//
//  Created by Norbu Sonam on 1/3/24.
//

import SwiftUI
import SwiftData

@main
struct routineApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Habit.self)
    }
}
