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
    
    @State private var firstDayOfCurrentWeek = DateHelpers.getFirstDayOfTheWeek(date: Date.now)
    @State private var selectedDate = Date.now
    @State private var numberOfWeeksToRender = Calendar.current.dateComponents(
        [.weekOfYear],
        from: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!,
        to: Calendar.current.date(byAdding: .day, value: 7, to: DateHelpers.getFirstDayOfTheWeek(date: Date.now))!)
        .weekOfYear!
    @State private var currentWeek = Calendar.current.dateComponents(
        [.weekOfYear],
        from: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!,
        to: DateHelpers.getFirstDayOfTheWeek(date: Date.now))
        .weekOfYear!
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
                Text(DateHelpers.getYearHeader(firstDayOfCurrentWeek))
                    .font(.largeTitle)
                Text(DateHelpers.getMonthSubheader(firstDayOfCurrentWeek))
                    .font(.callout)
            }
            .animation(.easeInOut, value: firstDayOfCurrentWeek)
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
                                selectedDate = day
                            }
                            .padding(10)
                            .foregroundColor(Calendar.current.isDateInToday(day) ? .accent : .primary)
                            .overlay(
                                Group {
                                    if Calendar.current.isDate(day, inSameDayAs: selectedDate) {
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
            .sensoryFeedback(.selection, trigger: selectedDate)
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
                firstDayOfCurrentWeek = Calendar.current.date(byAdding: .day, value: 7 * currentWeek, to: startOfTime)!
            }
            // +--------+
            // | habits |
            // +--------+
            ScrollView() {
                VStack(alignment: .leading) {
                    VStack(spacing: 0) {
                        ForEach(habits) { habit in
                            if DateHelpers.shouldShowHabit(selectedDate, habit) {
                                Button {
                                    openHabitSheet(habit)
                                } label: {
                                    Text("\(habit.emoji)")
                                    VStack(alignment: .leading) {
                                        Text("\(habit.name)")
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        Text("\(habit.getCompletionsOnDay(selectedDate)) / \(habit.goal)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "circle.dashed")
                                        .imageScale(.large)
                                }
                                .padding(.vertical)
                            }
                        }
                    }
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                .sheet(isPresented: $showHabitSheet) {
                    HabitSheetView(habit: $selectedHabit, date: $selectedDate)
                }
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
    
    static func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        return calendar.isDate(date1, equalTo: date2, toGranularity: .day)
    }
    
    static func isSameMonth(_ date1: Date, _ date2: Date) -> Bool {
        return calendar.isDate(date1, equalTo: date2, toGranularity: .month)
    }
    
    static func isSameYear(_ date1: Date, _ date2: Date) -> Bool {
        return calendar.isDate(date1, equalTo: date2, toGranularity: .year)
    }
    
    static func shouldShowHabit(_ selectedDate: Date, _ habit: Habit) -> Bool {
        // TODO: consider habit.days
        return isSameDay(selectedDate, habit.creationDate) || selectedDate > habit.creationDate
    }
    
    static func getYearHeader(_ firstDayOfWeek: Date) -> String {
        let lastDayOfWeek = calendar.date(byAdding: .day, value: 6, to: firstDayOfWeek)!
        return isSameYear(firstDayOfWeek, lastDayOfWeek)
        ? getYear(firstDayOfWeek)
        : getYear(firstDayOfWeek) + " - " + getYear(lastDayOfWeek)
    }
    
    static func getMonthSubheader(_ firstDayOfWeek: Date) -> String {
        let lastDayOfWeek = calendar.date(byAdding: .day, value: 6, to: firstDayOfWeek)!
        return isSameMonth(firstDayOfWeek, lastDayOfWeek)
        ? getMonth(firstDayOfWeek)
        : getMonth(firstDayOfWeek) + " - " + getMonth(lastDayOfWeek)
    }
}

#Preview {
    ContentView()
}
