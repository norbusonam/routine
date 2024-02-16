//
//  StatsView.swift
//  routine
//
//  Created by Norbu Sonam on 1/31/24.
//

import SwiftUI

struct StatsView: View {
    var body: some View {
        VStack {
            Text("Stats")
                .font(.largeTitle)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ContentView(currentPage: Page.stats)
}
