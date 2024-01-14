//
//  ContentView.swift
//  routine
//
//  Created by Norbu Sonam on 1/3/24.
//

import SwiftUI
import SwiftData

func getFirstDayOfTheWeek() -> Date {
    let today = Date()
    var calendar = Calendar.current
    calendar.firstWeekday = 2
    let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)
    return calendar.date(from: components)!
}

func getFirstLetterOfDay(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEEE"
    return formatter.string(from: date)
}

func getDayOfMonth(_ date: Date) -> String {
    let calendar = Calendar.current
    let dayOfMonth = calendar.component(.day, from: date)
    return String(dayOfMonth)
}

struct ContentView: View {
    @State private var selectedDate = Date.now
    
    var body: some View {
        HStack {
            Spacer()
            ForEach(0..<7, id: \.self) { index in
                let day = Calendar.current.date(byAdding: .day, value: index, to: getFirstDayOfTheWeek())!
                Button(action: {
                    selectedDate = day
                }) {
                    VStack(spacing: 10) {
                        Text(getFirstLetterOfDay(day))
                            .font(.system(.headline))
                        Text(getDayOfMonth(day))
                            .font(.system(.subheadline))
                    }
                }
                .padding(10)
                .foregroundColor(Calendar.current.isDateInToday(day) ? .purple : .black)
                .overlay(
                    Group {
                        if Calendar.current.isDate(day, inSameDayAs: selectedDate) {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.purple, lineWidth: 2)
                        }
                    }
                        .transition(.opacity)
                        .animation(.snappy(duration: 0.2), value: Calendar.current.isDate(day, inSameDayAs: selectedDate))
                )
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
