//
//  NewHabitSheetView.swift
//  routine
//
//  Created by Norbu Sonam on 2/2/24.
//

import SwiftUI

struct NewHabitSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Button {
             dismiss()
        } label: {
            Text("Dismiss")
        }
    }
}

#Preview {
    AuthenticatedView(showNewHabitSheet: true)
}
