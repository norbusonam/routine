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
    
    @State private var firstDayOfCurrentWeek = DateHelpers.getFirstDayOfTheWeek(for: Date.now)
    @State private var selectedDate = Date.now
    @State private var numberOfWeeksToRender = Calendar.current.dateComponents(
        [.weekOfYear],
        from: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!,
        to: Calendar.current.date(byAdding: .day, value: 7, to: DateHelpers.getFirstDayOfTheWeek(for: Date.now))!)
        .weekOfYear!
    @State private var currentWeek = Calendar.current.dateComponents(
        [.weekOfYear],
        from: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!,
        to: DateHelpers.getFirstDayOfTheWeek(for: Date.now))
        .weekOfYear!
    @State private var showFutureEditAlert = false
    @State private var showGoodHabits = true
    @State private var showBadHabits = true
    @State var selectedHabit: Habit = Habit()
    @State var showHabitSheet = false
    
    @Query var habits: [Habit]
    
    func openHabitSheet(_ habit: Habit) {
        selectedHabit = habit
        showHabitSheet = true
    }
    
    var body: some View {
        VStack {
            // +--------+
            // | header |
            // +--------+
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(DateHelpers.getYearHeader(for: firstDayOfCurrentWeek))
                        .font(.largeTitle)
                        .transition(AnyTransition.asymmetric(insertion: .push(from: .leading), removal: .push(from: .trailing)))
                        .id(DateHelpers.getYearHeader(for: firstDayOfCurrentWeek))
                    Text(DateHelpers.getMonthSubheader(for: firstDayOfCurrentWeek))
                        .font(.callout)
                        .transition(AnyTransition.asymmetric(insertion: .push(from: .leading), removal: .push(from: .trailing)))
                        .id(DateHelpers.getMonthSubheader(for: firstDayOfCurrentWeek))
                }
                Spacer()
                ShareLink(
                    item: URL(string: "https://testflight.apple.com/join/eviQ8Tiw")!,
                    preview: SharePreview("Invite others to beta test Routine")
                )
                .padding([.top], 8)
                .labelStyle(.iconOnly)
            }
            .padding(.top)
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
                                Text(DateHelpers.getFirstLetterOfDay(for: day))
                                    .font(.system(.headline))
                                Text(DateHelpers.getDayOfMonth(for: day))
                                    .font(.system(.subheadline))
                                    .foregroundColor(.secondary)
                            }
                            .padding(10)
                            .foregroundColor(Calendar.current.isDateInToday(day) ? .accent : .primary)
                            .overlay {
                                Group {
                                    if Calendar.current.isDate(day, inSameDayAs: selectedDate) {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.accent, lineWidth: 2)
                                            .transition(.push(from: .leading))
                                    }
                                }
                            }
                            .onTapGesture {
                                withAnimation {
                                    selectedDate = day
                                }
                            }
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
            .onChange(of: currentWeek) {
                if currentWeek == numberOfWeeksToRender {
                    numberOfWeeksToRender += 1
                }
                withAnimation {
                    firstDayOfCurrentWeek = Calendar.current.date(byAdding: .day, value: 7 * currentWeek, to: startOfTime)!
                }
            }
            // +--------+
            // | habits |
            // +--------+
            let goodHabits = habits.filter({ $0.shouldShow(on: selectedDate) && $0.type == .good })
            let badHabits = habits.filter({ $0.shouldShow(on: selectedDate) && $0.type == .bad })
            if goodHabits.count + badHabits.count > 0 {
                List {
                    if goodHabits.count > 0 {
                        Section(isExpanded: $showGoodHabits) {
                            ForEach(goodHabits) { habit in
                                HabitListItem(habit: habit, selectedDate: selectedDate, showFutureEditAlert: $showFutureEditAlert) {
                                    openHabitSheet(habit)
                                }
                            }
                        } header: {
                            HStack {
                                Text("Good Habits")
                                Spacer()
                                Button {
                                    withAnimation {
                                        showGoodHabits.toggle()
                                    }
                                } label: {
                                    Image(systemName: "chevron.down")
                                        .rotationEffect(.degrees(showGoodHabits ? 180 : 0))
                                }
                            }
                        }
                    }
                    if badHabits.count > 0 {
                        Section(isExpanded: $showBadHabits) {
                            ForEach(badHabits) { habit in
                                HabitListItem(habit: habit, selectedDate: selectedDate, showFutureEditAlert: $showFutureEditAlert) {
                                    openHabitSheet(habit)
                                }
                            }
                        } header: {
                            HStack {
                                Text("Bad Habits")
                                Spacer()
                                Button {
                                    withAnimation {
                                        showBadHabits.toggle()
                                    }
                                } label: {
                                    Image(systemName: "chevron.down")
                                        .rotationEffect(.degrees(showBadHabits ? 180 : 0))
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .sensoryFeedback(.impact, trigger: showHabitSheet, condition: { _, newValue in
                    return newValue == true
                })
                .sheet(isPresented: $showHabitSheet) {
                    HabitSheetView(habit: selectedHabit, date: selectedDate)
                }
                .alert("Nice try, but you can't do a habit in the future!", isPresented: $showFutureEditAlert) {
                    Button("Ok", role: .cancel, action: {})
                }
                .mask(
                    LinearGradient(
                        gradient: Gradient(
                            stops: [
                                .init(color: .primary, location: 0.95),
                                .init(color: .clear, location: 1)
                            ]
                        ),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            } else {
                VStack {
                    Spacer()
                    Text("No habits for this day. Press + below to create one!")
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                }
            }
        }
    }
}

struct HabitListItem: View {
    var habit: Habit
    var selectedDate: Date
    @Binding var showFutureEditAlert: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            let habitState = habit.getState(on: selectedDate)
            HStack {
                Text("\(habit.emoji)")
                VStack(alignment: .leading) {
                    Text("\(habit.name)")
                        .font(.headline)
                        .lineLimit(1)
                        .foregroundColor(
                            !Calendar.current.isDateInToday(selectedDate) && selectedDate > Date.now
                            ? .secondary
                            : .primary)
                    HStack(spacing: 0) {
                        Text("\(habit.getCompletions(on: selectedDate))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .transition(.scale)
                            .id(habit.getCompletions(on: selectedDate))
                        Text(" / \(habit.goal)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer(minLength: 32)
                switch habitState {
                case .exceeded:
                    Text("👏")
                        .transition(.scale)
                case .success:
                    Text("✅")
                        .transition(.scale)
                case .fail:
                    Text("❌")
                        .transition(.scale)
                case .inProgress:
                    ZStack {
                        Circle()
                            .stroke(.accent, lineWidth: 3)
                            .opacity(0.4)
                        Circle()
                            .trim(
                                from: 0,
                                to: [habit.getProgress(on: selectedDate), 0.00001].max()!
                            )
                            .stroke(.accent, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                    }
                    .transition(.scale)
                    .frame(width: 24, height: 24)
                }
            }
            .contentShape(Rectangle())
        }
        .padding()
        .buttonStyle(.plain)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets())
        .swipeActions(edge: .leading) {
            Button {
                withAnimation {
                    showFutureEditAlert = !habit.deleteCompletion(on: selectedDate)
                }
            } label: {
                Image(systemName: "minus")
            }
            .tint(habit.type == .good ? .red : .green)
        }
        .swipeActions(edge: .trailing) {
            Button {
                withAnimation {
                    showFutureEditAlert = !habit.addCompletion(on: selectedDate)
                }
            } label: {
                Image(systemName: "plus")
            }
            .tint(habit.type == .good ? .green : .red)
        }
    }
}

fileprivate struct DateHelpers {
    static var calendar = Calendar.current
    
    static func getFirstDayOfTheWeek(for date: Date) -> Date {
        calendar.firstWeekday = 2
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return calendar.date(from: components)!
    }
    
    static func getFirstLetterOfDay(for date: Date) -> String {
        let weekdayStyle = Date.FormatStyle().weekday(.wide)
        return "\(date.formatted(weekdayStyle).first!)"
    }
    
    static func getMonth(for date: Date) -> String {
        let monthStyle = Date.FormatStyle().month(.wide)
        return date.formatted(monthStyle)
    }
    
    static func getDayOfMonth(for date: Date) -> String {
        let dayOfMonth = calendar.component(.day, from: date)
        return String(dayOfMonth)
    }
    
    static func getYear(for date: Date) -> String {
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
    
    static func getYearHeader(for firstDayOfWeek: Date) -> String {
        let lastDayOfWeek = calendar.date(byAdding: .day, value: 6, to: firstDayOfWeek)!
        return isSameYear(firstDayOfWeek, lastDayOfWeek)
        ? getYear(for: firstDayOfWeek)
        : getYear(for: firstDayOfWeek) + " - " + getYear(for: lastDayOfWeek)
    }
    
    static func getMonthSubheader(for firstDayOfWeek: Date) -> String {
        let lastDayOfWeek = calendar.date(byAdding: .day, value: 6, to: firstDayOfWeek)!
        return isSameMonth(firstDayOfWeek, lastDayOfWeek)
        ? getMonth(for: firstDayOfWeek)
        : getMonth(for: firstDayOfWeek) + " - " + getMonth(for: lastDayOfWeek)
    }
}

#Preview {
    ContentView()
}
