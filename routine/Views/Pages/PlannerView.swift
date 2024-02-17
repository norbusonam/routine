//
//  PlannerView.swift
//  routine
//
//  Created by Norbu Sonam on 1/3/24.
//

import SwiftUI
import SwiftData

struct PlannerView: View {
    // TODO: update to when user created account
    private let startOfTime = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!
    
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
    
    @State var selectedHabit: Habit = Habit()
    @State var showHabitSheet = false
    
    @Query var habits: [Habit]
    
    func openHabitSheet(_ habit: Habit) {
        selectedHabit = habit
        showHabitSheet = true
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // +--------+
            // | header |
            // +--------+
            VStack(alignment: .leading) {
                Text(DateHelpers.getYearHeader(firstDayOfCurrentWeekEpoch))
                    .font(.largeTitle)
                Text(DateHelpers.getMonthSubheader(firstDayOfCurrentWeekEpoch))
                    .font(.callout)
            }
            .animation(.easeInOut, value: firstDayOfCurrentWeekEpoch)
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
                            VStack(spacing: 10) {
                                Text(DateHelpers.getFirstLetterOfDay(day))
                                    .font(.system(.headline))
                                Text(DateHelpers.getDayOfMonth(day))
                                    .font(.system(.subheadline))
                            }
                            .onTapGesture {
                                selectedDateEpoch = day.timeIntervalSince1970
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
                    Text(DateHelpers.getDayLabel(selectedDateEpoch))
                    VStack(spacing: 0) {
                        ForEach(habits) { habit in
                            if DateHelpers.shouldShowHabit(selectedDateEpoch, habit) {
                                Button {
                                    openHabitSheet(habit)
                                } label: {
                                    Text("\(habit.emoji)")
                                    VStack(alignment: .leading) {
                                        Text("\(habit.name)")
                                            .font(.headline)
                                        Text("1/\(habit.goal)")
                                            .font(.subheadline)
                                    }
                                    Spacer()
                                    Image(systemName: "circle.dashed")
                                }
                                .padding(.vertical)
                            }
                        }
                    }
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                .sheet(isPresented: $showHabitSheet) {
                    HabitSheetView(habit: $selectedHabit)
                }
            }
            .mask(
                LinearGradient(
                    gradient: Gradient(
                        stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .primary, location: 0.04),
                            .init(color: .primary, location: 0.96),
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
    
    static func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        return calendar.isDate(date1, equalTo: date2, toGranularity: .day)
    }
    
    static func isSameMonth(_ date1: Date, _ date2: Date) -> Bool {
        return calendar.isDate(date1, equalTo: date2, toGranularity: .month)
    }
    
    static func isSameYear(_ date1: Date, _ date2: Date) -> Bool {
        return calendar.isDate(date1, equalTo: date2, toGranularity: .year)
    }
    
    static func shouldShowHabit(_ selectedDateEpoch: TimeInterval, _ habit: Habit) -> Bool {
        let selecteDate = Date(timeIntervalSince1970: selectedDateEpoch)
        // TODO: consider habit.days
        return isSameDay(selecteDate, habit.creationDate) || selecteDate > habit.creationDate
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
    
    static func getDayLabel(_ dayEpoch: TimeInterval) -> String {
        let day = Date(timeIntervalSince1970: dayEpoch)
        if (calendar.isDateInToday(day)) {
            return "Today"
        } else if (calendar.isDateInTomorrow(day)) {
            return "Tomorrow"
        } else if (calendar.isDateInYesterday(day)) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            if (calendar.isDate(day, equalTo: Date.now, toGranularity: .year)) {
                formatter.dateFormat = "M/d"
            } else {
                formatter.dateFormat = "M/d/yy"
            }
            return formatter.string(from: day)
        }
    }
}

#Preview {
    ContentView()
}
