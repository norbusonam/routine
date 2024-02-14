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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Habit.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    // TODO: auth check logic
    let authenticated = true
    var body: some Scene {
        WindowGroup {
            if authenticated {
                AuthenticatedView()
            } else {
                UnauthenticatedView()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
