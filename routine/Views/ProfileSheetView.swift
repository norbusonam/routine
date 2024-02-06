//
//  ProfileSheetView.swift
//  routine
//
//  Created by Norbu Sonam on 2/6/24.
//

import SwiftUI

struct ProfileSheetView: View {
    var body: some View {
        Button {
        } label: {
            Text("Sign Out")
                .foregroundColor(.red)
        }
    }
}

#Preview {
    AuthenticatedView(showProfileSheet: true)
}
