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

struct PlannerView: View {
    @State private var firstDayOfCurrentWeek = getFirstDayOfTheWeek()
    @State private var lastDayOfCurrentWeek = Calendar.current.date(byAdding: .day, value: 6, to: getFirstDayOfTheWeek())!
    @State private var renderFromRelativeWeek = -1
    @State private var renderToRelativeWeek = 1
    @State private var currentWeek = 0
    @State private var selectedDate = Date.now
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(
                    Calendar.current.isDate(firstDayOfCurrentWeek, equalTo: lastDayOfCurrentWeek, toGranularity: .year)
                    ? getYear(firstDayOfCurrentWeek)
                    : getYear(firstDayOfCurrentWeek) + " - " + getYear(lastDayOfCurrentWeek)
                )
                .font(.largeTitle)
                .padding(.leading)
                Text(
                    Calendar.current.isDate(firstDayOfCurrentWeek, equalTo: lastDayOfCurrentWeek, toGranularity: .month)
                    ? getMonth(firstDayOfCurrentWeek)
                    : getMonth(firstDayOfCurrentWeek) + " - " + getMonth(lastDayOfCurrentWeek)
                )
                .font(.callout)
                .padding(.leading)
            }
            TabView(selection: $currentWeek) {
                ForEach(renderFromRelativeWeek...renderToRelativeWeek, id: \.self) { weekRelativeToThisWeek in
                    let firstDayOfWeek = Calendar.current.date(byAdding: .day, value: weekRelativeToThisWeek * 7, to: getFirstDayOfTheWeek())!
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
                            )
                            Spacer()
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .onChange(of: currentWeek, initial: false) {
                if currentWeek == renderToRelativeWeek {
                    renderToRelativeWeek += 1
                } else if currentWeek == renderFromRelativeWeek {
                    renderFromRelativeWeek -= 1
                }
                firstDayOfCurrentWeek = Calendar.current.date(byAdding: .day, value: 7 * currentWeek, to: getFirstDayOfTheWeek())!
                lastDayOfCurrentWeek = Calendar.current.date(byAdding: .day, value: 6, to: firstDayOfCurrentWeek)!
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
}

#Preview {
    AuthenticatedView()
}
