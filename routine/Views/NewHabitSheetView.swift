//
//  NewHabitSheetView.swift
//  routine
//
//  Created by Norbu Sonam on 2/2/24.
//

import SwiftUI

struct NewHabitSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var habit = Habit()
    @State var page = 0
    
    var body: some View {
        VStack() {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                }
                .padding()
            }
            Spacer()
            Text(String(page))
            HStack {
                if page > 0 {
                    Button("Previous") {
                        page = [0, page - 1].max()!
                    }
                }
                if page < 6 {
                    Button("Next") {
                        page = [page + 1, 6].min()!
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    AuthenticatedView(showNewHabitSheet: true)
}
