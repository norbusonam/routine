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
        .modelContainer(for: Habit.self)
    }
}
