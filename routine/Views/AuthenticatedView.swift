//
//  AuthenticatedView.swift
//  routine
//
//  Created by Norbu Sonam on 1/26/24.
//

import SwiftUI

struct AuthenticatedView: View {
    var body: some View {
        TabView() {
            PlannerView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Planner")
                }
        }
    }
}

#Preview {
    AuthenticatedView()
}
