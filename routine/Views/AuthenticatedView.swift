//
//  AuthenticatedView.swift
//  routine
//
//  Created by Norbu Sonam on 1/26/24.
//

import SwiftUI

struct AuthenticatedView: View {
    @State var currentPageName: String = "planner";
    
    var body: some View {
        VStack {
            // pages
            if currentPageName == "planner" {
                PlannerView()
            } else if currentPageName == "stats" {
                StatsView()
            }
            
            Spacer()
            
            // bottom bar
            HStack {
                TabItem(pageName: "planner", imageName: "calendar", currentPageName: $currentPageName)
                TabItem(pageName: "stats", imageName: "chart.bar", currentPageName: $currentPageName)
            }
        }
    }
}

struct TabItem: View {
    let pageName: String
    let imageName: String
    @Binding var currentPageName: String
    
    var body: some View {
        Button(action: {
            currentPageName = pageName
        }, label: {
            Spacer()
            Image(systemName: imageName)
                .imageScale(.large)
                .foregroundColor(pageName == currentPageName ? .accentColor : .primary)
            Spacer()
        })
        .padding()
    }
}

#Preview {
    AuthenticatedView()
}
