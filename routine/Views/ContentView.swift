//
//  ContentView.swift
//  routine
//
//  Created by Norbu Sonam on 1/3/24.
//

import SwiftUI

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

func getMonth(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM"
    return formatter.string(from: date)
}

func getDayOfMonth(_ date: Date) -> String {
    let calendar = Calendar.current
    let dayOfMonth = calendar.component(.day, from: date)
    return String(dayOfMonth)
}

func getYear(_ date: Date) -> String {
    let calendar = Calendar.current
    let year = calendar.component(.year, from: date)
    return String(year)
}

struct ContentView: View {
    @State private var firstDayOfTheWeek = getFirstDayOfTheWeek()
    @State private var selectedDate = Date.now
    
    func shiftWeeks(_ weeks: Int) {
        firstDayOfTheWeek = Calendar.current.date(byAdding: .day, value: 7 * weeks, to: firstDayOfTheWeek)!
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(getYear(firstDayOfTheWeek))
                    .font(.largeTitle)
                    .padding(.leading)
                Text(getMonth(firstDayOfTheWeek))
                    .font(.callout)
                    .padding(.leading)
            }
            HStack {
                Spacer()
                Button {
                    shiftWeeks(-1)
                } label: {
                    Image(systemName: "arrow.left").foregroundColor(.purple)
                }
                Spacer()
                ForEach(0..<7, id: \.self) { index in
                    let day = Calendar.current.date(byAdding: .day, value: index, to: firstDayOfTheWeek)!
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
                Button {
                    shiftWeeks(1)
                } label: {
                    Image(systemName: "arrow.right").foregroundColor(.purple)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
