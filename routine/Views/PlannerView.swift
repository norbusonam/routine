//
//  PlannerView.swift
//  routine
//
//  Created by Norbu Sonam on 1/3/24.
//

import SwiftUI

struct PlannerView: View {
    @Binding var showProfileSheet: Bool
    
    // TODO: update to when user created account
    private var startOfTime = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!
    
    @SceneStorage("firstDayOfCurrentWeekEpoch") private var firstDayOfCurrentWeekEpoch = DateHelpers.getFirstDayOfTheWeek(date: Date.now).timeIntervalSince1970
    @SceneStorage("numberOfWeeksToRender") private var numberOfWeeksToRender = Calendar.current.dateComponents(
        [.weekOfYear],
        from: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!,
        to: Calendar.current.date(byAdding: .day, value: 7, to: DateHelpers.getFirstDayOfTheWeek(date: Date.now))!)
        .weekOfYear!
    @SceneStorage("currentWeek") private var currentWeek = Calendar.current.dateComponents(
        [.weekOfYear],
        from: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!,
        to: DateHelpers.getFirstDayOfTheWeek(date: Date.now))
        .weekOfYear!
    @SceneStorage("selectedDateEpoch") private var selectedDateEpoch = Date.now.timeIntervalSince1970
    
    public init(showProfileSheet: Binding<Bool>) {
        self._showProfileSheet = showProfileSheet
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // +--------+
            // | header |
            // +--------+
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(DateHelpers.getYearHeader(firstDayOfCurrentWeekEpoch))
                        .font(.largeTitle)
                    Text(DateHelpers.getMonthSubheader(firstDayOfCurrentWeekEpoch))
                        .font(.callout)
                }
                .animation(.easeInOut, value: firstDayOfCurrentWeekEpoch)
                Spacer()
                Button {
                    showProfileSheet = true
                } label: {
                    Image(systemName: "person.crop.circle")
                        .imageScale(.large)
                }
            }
            .padding(.horizontal)
            // +---------------+
            // | week carousel |
            // +---------------+
            TabView(selection: $currentWeek) {
                ForEach(0...numberOfWeeksToRender, id: \.self) { weekRelativeToThisWeek in
                    let firstDayOfWeek = Calendar.current.date(byAdding: .day, value: weekRelativeToThisWeek * 7, to: startOfTime)!
                    HStack {
                        Spacer()
                        ForEach(0..<7, id: \.self) { index in
                            let day = Calendar.current.date(byAdding: .day, value: index, to: firstDayOfWeek)!
                            Button {
                                selectedDateEpoch = day.timeIntervalSince1970
                            } label: {
                                VStack(spacing: 10) {
                                    Text(DateHelpers.getFirstLetterOfDay(day))
                                        .font(.system(.headline))
                                    Text(DateHelpers.getDayOfMonth(day))
                                        .font(.system(.subheadline))
                                }
                            }
                            .padding(10)
                            .foregroundColor(Calendar.current.isDateInToday(day) ? .accent : .primary)
                            .overlay(
                                Group {
                                    if Calendar.current.isDate(day, inSameDayAs: Date(timeIntervalSince1970: selectedDateEpoch)) {
                                        RoundedRectangle(cornerRadius: 10)
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
            .frame(height: 100)
            .sensoryFeedback(.selection, trigger: selectedDateEpoch)
            .mask(
                LinearGradient(
                    gradient: Gradient(
                        stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .primary, location: 0.05),
                            .init(color: .primary, location: 0.95),
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
                firstDayOfCurrentWeekEpoch = Calendar.current.date(byAdding: .day, value: 7 * currentWeek, to: startOfTime)!.timeIntervalSince1970
            }
            // +--------+
            // | habits |
            // +--------+
            ScrollView() {
                VStack(alignment: .leading) {
                    Text("Today")
                    Text("This Week")
                    Text("This Month")
                    Text("This Year")
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
            }
            .mask(
                LinearGradient(
                    gradient: Gradient(
                        stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .primary, location: 0.05),
                            .init(color: .primary, location: 0.95),
                            .init(color: .clear, location: 1)
                        ]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
    }
}

fileprivate struct DateHelpers {
    static var calendar = Calendar.current
    
    static func getFirstDayOfTheWeek(date: Date) -> Date {
        calendar.firstWeekday = 2
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return calendar.date(from: components)!
    }

    static func getFirstLetterOfDay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEEE"
        return formatter.string(from: date)
    }

    static func getMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: date)
    }

    static func getDayOfMonth(_ date: Date) -> String {
        let dayOfMonth = calendar.component(.day, from: date)
        return String(dayOfMonth)
    }

    static func getYear(_ date: Date) -> String {
        let year = calendar.component(.year, from: date)
        return String(year)
    }

    static func isSameMonth(_ date1: Date, _ date2: Date) -> Bool {
        return calendar.isDate(date1, equalTo: date2, toGranularity: .month)
    }

    static func isSameYear(_ date1: Date, _ date2: Date) -> Bool {
        return calendar.isDate(date1, equalTo: date2, toGranularity: .year)
    }

    static func getYearHeader(_ firstDayOfWeekEpoch: TimeInterval) -> String {
        let firstDayOfWeek = Date(timeIntervalSince1970: firstDayOfWeekEpoch)
        let lastDayOfWeek = calendar.date(byAdding: .day, value: 6, to: firstDayOfWeek)!
        return isSameYear(firstDayOfWeek, lastDayOfWeek)
            ? getYear(firstDayOfWeek)
            : getYear(firstDayOfWeek) + " - " + getYear(lastDayOfWeek)
    }

    static func getMonthSubheader(_ firstDayOfWeekEpoch: TimeInterval) -> String {
        let firstDayOfWeek = Date(timeIntervalSince1970: firstDayOfWeekEpoch)
        let lastDayOfWeek = calendar.date(byAdding: .day, value: 6, to: firstDayOfWeek)!
        return isSameMonth(firstDayOfWeek, lastDayOfWeek)
            ? getMonth(firstDayOfWeek)
            : getMonth(firstDayOfWeek) + " - " + getMonth(lastDayOfWeek)
    }
}

#Preview {
    AuthenticatedView()
}
