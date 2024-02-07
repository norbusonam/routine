//
//  ProfileSheetView.swift
//  routine
//
//  Created by Norbu Sonam on 2/6/24.
//

import SwiftUI

struct ProfileSheetView: View {
    var body: some View {
        List{
            Button {
            } label: {
                Text("Sign Out")
                    .foregroundColor(.red)
            }
        }
        .scrollDisabled(true)
    }
}

#Preview {
    AuthenticatedView(showProfileSheet: true)
}
