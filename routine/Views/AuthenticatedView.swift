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
                    Image(systemName: "1.square.fill")
                    Text("First")
                }
        }
    }
}

#Preview {
    AuthenticatedView()
}
