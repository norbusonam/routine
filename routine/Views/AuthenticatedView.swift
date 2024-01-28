//
//  AuthenticatedView.swift
//  routine
//
//  Created by Norbu Sonam on 1/26/24.
//

import SwiftUI

struct AuthenticatedView: View {
    @State private var selection = 0
    var body: some View {
        TabView(selection: $selection) {
            Text("First View")
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("First")
                }
                .tag(0)
            
            Text("Second View")
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Second")
                }
                .tag(1)
            
            Text("Third View")
                .tabItem {
                    Image(systemName: "3.square.fill")
                    Text("Third")
                }
                .tag(2)
        }
    }
}

#Preview {
    AuthenticatedView()
}
