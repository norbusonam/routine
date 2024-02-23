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
            // +--------+
            // | header |
            // +--------+
            HStack(alignment: .top) {
                Text("Stats")
                    .font(.largeTitle)
                Spacer()
                ShareLink(
                    item: URL(string: "https://testflight.apple.com/join/eviQ8Tiw")!,
                    preview: SharePreview("Invite others to beta test Routine")
                )
                .labelStyle(.iconOnly)
                .padding([.top], 8)
            }
            .padding(.top)
            .padding(.horizontal)
            Spacer()
            Text("🚧 Under Construction 🚧")
            Spacer()
        }
    }
}

#Preview {
    ContentView(currentPage: Page.stats)
        .modelContainer(previewContainer)
}
