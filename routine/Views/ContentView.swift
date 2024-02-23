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
        VStack {
            // pages
            if currentPage == Page.planner {
                PlannerView()
                    .transition(.asymmetric(insertion: .push(from: .leading), removal: .push(from: .trailing)))
            } else if currentPage == Page.stats {
                StatsView()
                    .transition(.asymmetric(insertion: .push(from: .trailing), removal: .push(from: .leading)))
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
                    EditHabitSheetView(isNewHabit: true)
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
            withAnimation {
                currentPage = page
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(previewContainer)
}
