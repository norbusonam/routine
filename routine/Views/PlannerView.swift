//
//  ContentView.swift
//  routine
//
//  Created by Norbu Sonam on 1/3/24.
//

import SwiftUI

func getFirstDayOfTheWeek(date: Date) -> Date {
    var calendar = Calendar.current
    calendar.firstWeekday = 2
    let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
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
    // TODO: update to when user created account
    private var startOfTime = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!
    
    @State private var firstDayOfCurrentWeek = getFirstDayOfTheWeek(date: Date.now)
    @State private var lastDayOfCurrentWeek = Calendar.current.date(byAdding: .day, value: 6, to: getFirstDayOfTheWeek(date: Date.now))!
    @State private var numberOfWeeksToRender = Calendar.current.dateComponents(
        [.weekOfYear],
        from: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!,
        to: Calendar.current.date(byAdding: .day, value: 7, to: getFirstDayOfTheWeek(date: Date.now))!)
        .weekOfYear!
    @State private var currentWeek = Calendar.current.dateComponents(
        [.weekOfYear],
        from: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!,
        to: getFirstDayOfTheWeek(date: Date.now))
        .weekOfYear!
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
                ForEach(0...numberOfWeeksToRender, id: \.self) { weekRelativeToThisWeek in
                    let firstDayOfWeek = Calendar.current.date(byAdding: .day, value: weekRelativeToThisWeek * 7, to: startOfTime)!
                    HStack {
                        Spacer()
                        ForEach(0..<7, id: \.self) { index in
                            let day = Calendar.current.date(byAdding: .day, value: index, to: firstDayOfWeek)!
                            Button {
                                selectedDate = day
                            } label: {
                                VStack(spacing: 10) {
                                    Text(getFirstLetterOfDay(day))
                                        .font(.system(.headline))
                                    Text(getDayOfMonth(day))
                                        .font(.system(.subheadline))
                                }
                            }
                            .padding(10)
                            .foregroundColor(Calendar.current.isDateInToday(day) ? .accent : .primary)
                            .overlay(
                                Group {
                                    if Calendar.current.isDate(day, inSameDayAs: selectedDate) {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(.accent, lineWidth: 2)
                                    }
                                }
                            )
                            Spacer()
                        }
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 80)
            .mask(
                LinearGradient(
                    gradient: Gradient(
                        stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .black, location: 0.05),
                            .init(color: .black, location: 0.95),
                            .init(color: .clear, location: 1)
                        ]
                    ),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .onChange(of: currentWeek, initial: false) {
                if (currentWeek == numberOfWeeksToRender) {
                    numberOfWeeksToRender += 1
                }
                firstDayOfCurrentWeek = Calendar.current.date(byAdding: .day, value: 7 * currentWeek, to: startOfTime)!
                lastDayOfCurrentWeek = Calendar.current.date(byAdding: .day, value: 6, to: firstDayOfCurrentWeek)!
            }
            ScrollView() {
                VStack(alignment: .leading) {
                    Text("Today")
                    Text("This Week")
                    Text("This Month")
                    Text("This Year")
                }
            }
        }
    }
}

#Preview {
    AuthenticatedView()
}
