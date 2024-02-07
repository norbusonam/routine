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
        HStack {
            Text("New Habit")
                .font(.title)
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
            }
        }
        .padding()
        Spacer()
    }
}

#Preview {
    AuthenticatedView(showNewHabitSheet: true)
}
