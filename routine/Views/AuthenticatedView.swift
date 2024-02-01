//
//  AuthenticatedView.swift
//  routine
//
//  Created by Norbu Sonam on 1/26/24.
//

import SwiftUI

struct AuthenticatedView: View {
    @State var page: String = "planner";
    
    var body: some View {
        TabView(selection: $page) {
            PlannerView()
                .tabItem {
                    Label("Planner", systemImage: "calendar")
                }
                .tag("planner")
            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar")
                }
                .tag("stats")
            
        }
    }
}

#Preview {
    AuthenticatedView()
}
