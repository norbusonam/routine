//
//  PlannerView.swift
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

func isSameMonth(_ date1: Date, _ date2: Date) -> Bool {
    return Calendar.current.isDate(date1, equalTo: date2, toGranularity: .month)
}

func isSameYear(_ date1: Date, _ date2: Date) -> Bool {
    return Calendar.current.isDate(date1, equalTo: date2, toGranularity: .year)
}

func getYearHeader(_ firstDayOfWeekEpoch: TimeInterval) -> String {
    let firstDayOfWeek = Date(timeIntervalSince1970: firstDayOfWeekEpoch)
    let lastDayOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: firstDayOfWeek)!
    return isSameYear(firstDayOfWeek, lastDayOfWeek)
        ? getYear(firstDayOfWeek)
        : getYear(firstDayOfWeek) + " - " + getYear(lastDayOfWeek)
}

func getMonthSubheader(_ firstDayOfWeekEpoch: TimeInterval) -> String {
    let firstDayOfWeek = Date(timeIntervalSince1970: firstDayOfWeekEpoch)
    let lastDayOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: firstDayOfWeek)!
    return isSameMonth(firstDayOfWeek, lastDayOfWeek)
        ? getMonth(firstDayOfWeek)
        : getMonth(firstDayOfWeek) + " - " + getMonth(lastDayOfWeek)
}

struct PlannerView: View {
    @Binding var showProfileSheet: Bool
    
    // TODO: update to when user created account
    private var startOfTime = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!
    
    @SceneStorage("firstDayOfCurrentWeekEpoch") private var firstDayOfCurrentWeekEpoch = getFirstDayOfTheWeek(date: Date.now).timeIntervalSince1970
    @SceneStorage("numberOfWeeksToRender") private var numberOfWeeksToRender = Calendar.current.dateComponents(
        [.weekOfYear],
        from: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!,
        to: Calendar.current.date(byAdding: .day, value: 7, to: getFirstDayOfTheWeek(date: Date.now))!)
        .weekOfYear!
    @SceneStorage("currentWeek") private var currentWeek = Calendar.current.dateComponents(
        [.weekOfYear],
        from: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!,
        to: getFirstDayOfTheWeek(date: Date.now))
        .weekOfYear!
    @SceneStorage("selectedDateEpoch") private var selectedDateEpoch = Date.now.timeIntervalSince1970
    
    public init(showProfileSheet: Binding<Bool>) {
        self._showProfileSheet = showProfileSheet
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(getYearHeader(firstDayOfCurrentWeekEpoch))
                        .font(.largeTitle)
                    Text(getMonthSubheader(firstDayOfCurrentWeekEpoch))
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

#Preview {
    AuthenticatedView()
}
