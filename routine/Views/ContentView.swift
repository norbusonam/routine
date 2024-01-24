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
    @State private var lastDayOfTheWeek = Calendar.current.date(byAdding: .day, value: 6, to: getFirstDayOfTheWeek())!
    @State private var weeksBefore = -1
    @State private var weeksAfter = 1
    @State private var currentWeek = 0
    @State private var selectedDate = Date.now
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(
                    Calendar.current.isDate(firstDayOfTheWeek, equalTo: lastDayOfTheWeek, toGranularity: .year)
                    ? getYear(firstDayOfTheWeek)
                    : getYear(firstDayOfTheWeek) + " - " + getYear(lastDayOfTheWeek)
                )
                .font(.largeTitle)
                .padding(.leading)
                Text(
                    Calendar.current.isDate(firstDayOfTheWeek, equalTo: lastDayOfTheWeek, toGranularity: .month)
                    ? getMonth(firstDayOfTheWeek)
                    : getMonth(firstDayOfTheWeek) + " - " + getMonth(lastDayOfTheWeek)
                )
                .font(.callout)
                .padding(.leading)
            }
            TabView(selection: $currentWeek) {
                ForEach(weeksBefore...weeksAfter, id: \.self) { weeksRelativeToThisWeek in
                    let firstDayOfWeek = Calendar.current.date(byAdding: .day, value: weeksRelativeToThisWeek * 7, to: firstDayOfTheWeek)!
                    HStack {
                        Spacer()
                        ForEach(0..<7, id: \.self) { index in
                            let day = Calendar.current.date(byAdding: .day, value: index, to: firstDayOfWeek)!
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
                                    .animation(.snappy(duration: 0.2), value: Calendar.current.isDate(day, inSameDayAs: selectedDate))
                            )
                            Spacer()
                        }
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .onChange(of: currentWeek, initial: false) {
                if currentWeek == weeksAfter {
                    weeksAfter += 1
                } else if currentWeek == weeksBefore {
                    weeksBefore -= 1
                }
            }
        }
        ScrollView() {
            VStack(alignment: .leading) {
                Text("Today")
                Text("This Week")
                Text("This Month")
                Text("This Year")
            }
            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
            .padding(.leading)
        }
    }
}

#Preview {
    ContentView()
}
