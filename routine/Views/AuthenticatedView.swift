//
//  AuthenticatedView.swift
//  routine
//
//  Created by Norbu Sonam on 1/26/24.
//

import SwiftUI

struct AuthenticatedView: View {
    @State var currentPageName: String = "planner";
    @State var showNewHabitSheet = false;
    
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
                Button {
                    showNewHabitSheet = true;
                } label: {
                    Image(systemName: "plus")
                        .imageScale(.large)
                        .foregroundColor(.primary)
                }
                .sheet(isPresented: $showNewHabitSheet, content: {
                    NewHabitSheetView()
                        .interactiveDismissDisabled()
                        .presentationCornerRadius(55)
                })
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
        Button {
            currentPageName = pageName
        } label: {
            Spacer()
            Image(systemName: imageName)
                .imageScale(.large)
                .foregroundColor(pageName == currentPageName ? .accentColor : .primary)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    AuthenticatedView()
}
