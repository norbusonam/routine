//
//  StatsView.swift
//  routine
//
//  Created by Norbu Sonam on 1/31/24.
//

import SwiftUI

struct StatsView: View {
    @Binding var showProfileSheet: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            Text("Stats")
                .font(.largeTitle)
                .padding(.leading)
            Spacer()
            Button {
                showProfileSheet = true
            } label: {
                Image(systemName: "person.crop.circle")
                    .imageScale(.large)
                    .padding()
            }
            
        }
    }
}

#Preview {
    AuthenticatedView(currentPage: Page.stats)
}
