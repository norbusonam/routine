//
//  ProfileSheetView.swift
//  routine
//
//  Created by Norbu Sonam on 2/6/24.
//

import SwiftUI

struct ProfileSheetView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State var showConfirmClear = false
    
    var body: some View {
        List {
            Button("Clear all data") {
                do {
                    try modelContext.delete(model: Habit.self)
                } catch {
                    // TODO: handle delete failure
                }
                dismiss()
            }
            .foregroundColor(.red)
        }
        .scrollDisabled(true)
    }
}

#Preview {
    AuthenticatedView(showProfileSheet: true)
}
