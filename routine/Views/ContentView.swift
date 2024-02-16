//
//  ContentView.swift
//  routine
//
//  Created by Norbu Sonam on 1/26/24.
//

import SwiftUI

enum Page: String {
    case planner, stats
}

struct ContentView: View {
    @State var currentPage = Page.planner
    @State var showNewHabitSheet = false
    
    var body: some View {
        VStack(alignment: .leading) {
            // pages
            if currentPage == Page.planner {
                PlannerView()
            } else if currentPage == Page.stats {
                StatsView()
            }
            
            Spacer()
            
            // bottom bar
            HStack {
                TabItem(page: Page.planner, imageName: "calendar", currentPage: $currentPage)
                Button {
                    showNewHabitSheet = true
                } label: {
                    Image(systemName: "plus")
                        .imageScale(.large)
                        .foregroundColor(.white)
                }
                .padding()
                .background(
                    Circle()
                        .fill(.accent)
                )
                .sheet(isPresented: $showNewHabitSheet, content: {
                    NewHabitSheetView()
                        .interactiveDismissDisabled()
                })
                .sensoryFeedback(.impact, trigger: showNewHabitSheet) { _, newValue in
                    newValue == true
                }
                TabItem(page: Page.stats, imageName: "chart.bar", currentPage: $currentPage)
            }
            .sensoryFeedback(.selection, trigger: currentPage)
        }
    }
}

struct TabItem: View {
    let page: Page
    let imageName: String
    @Binding var currentPage: Page
    
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: imageName)
                .imageScale(.large)
                .foregroundColor(page == currentPage ? .accent : .primary)
            Spacer()
        }
        .padding()
        .onTapGesture {
            currentPage = page
        }
    }
}

#Preview {
    ContentView()
}
