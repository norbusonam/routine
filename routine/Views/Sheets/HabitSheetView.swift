//
//  HabitSheetView.swift
//  routine
//
//  Created by Norbu Sonam on 2/16/24.
//

import SwiftUI

struct HabitSheetView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var showEditSheet = false
    @State private var showFutureEditAlert = false
    @State private var showSwipeUpMessage = false
    
    private let haptic = UINotificationFeedbackGenerator()
    var habit: Habit
    var date: Date
    
    func deleteTask() {
        modelContext.delete(habit)
        dismiss()
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        // +--------------+
                        // | habit logger |
                        // +--------------+
                        VStack {
                            Spacer()
                            ZStack {
                                Circle()
                                    .stroke(.accent, lineWidth: 20)
                                    .opacity(0.4)
                                Circle()
                                    .trim(
                                        from: 0,
                                        to: [habit.getProgress(on: date), 0.00001].max()!
                                    )
                                    .stroke(.accent, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                                    .rotationEffect(.degrees(-90))
                                VStack(spacing: 10) {
                                    let habitState = habit.getState(on: date)
                                    switch habitState {
                                    case .exceeded, .success, .fail, .atLimit:
                                        Text(habitState.rawValue)
                                            .font(.largeTitle)
                                            .transition(.scale)
                                            .id(habitState)
                                    case .inProgress:
                                        Text(habit.emoji)
                                            .font(.largeTitle)
                                            .transition(.scale)
                                    }
                                    Text(habit.name)
                                        .padding(.horizontal)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(1)
                                        .font(.headline)
                                    HStack(spacing: 0) {
                                        Text("\(habit.getCompletions(on: date))")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .transition(.scale)
                                            .id(habit.getCompletions(on: date))
                                        Text(" / \(habit.goal)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.75)
                            Spacer()
                            HStack {
                                Spacer()
                                Button("", systemImage: "minus") {
                                    withAnimation {
                                        showFutureEditAlert = !habit.deleteCompletion(on: date)
                                    }
                                }
                                .font(.title)
                                .disabled(habit.getCompletions(on: date) == 0)
                                Spacer()
                                Button("", systemImage: "plus") {
                                    withAnimation {
                                        showFutureEditAlert = !habit.addCompletion(on: date)
                                    }
                                }
                                .font(.title)
                                Spacer()
                            }
                            Spacer()
                        }
                        .frame(height: geometry.size.height)
                        .padding(geometry.safeAreaInsets)
                        .overlay(alignment: .bottom) {
                            Group {
                                if showSwipeUpMessage {
                                    HStack {
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                        Spacer()
                                        Text("Swipe up for stats")
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                        Spacer()
                                    }
                                    .font(.footnote)
                                    .bold()
                                    .transition(.asymmetric(insertion: .push(from: .bottom), removal: .opacity))
                                }
                            }
                            .padding(.bottom, geometry.safeAreaInsets.bottom + 10)
                        }
                        .onAppear {
                            withAnimation(.easeOut(duration: 3)) {
                                showSwipeUpMessage = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation(.easeOut(duration: 1)) {
                                    showSwipeUpMessage = false
                                }
                            }
                        }
                        // +--------------+
                        // | habit logger |
                        // +--------------+
                        VStack {
                            Text("🚧 Under Construction 🚧")
                        }
                        .frame(height: geometry.size.height)
                        .padding(geometry.safeAreaInsets)
                    }
                }
                .ignoresSafeArea()
                .scrollTargetBehavior(.paging)
                .scrollIndicators(.hidden)
                .gesture(
                    DragGesture()
                        .onChanged({ _ in
                            withAnimation {
                                showSwipeUpMessage = false
                            }
                        })
                )
            }
            .onChange(of: habit.getState(on: date), { _, newValue in
                if newValue == .success || newValue == .exceeded {
                    haptic.notificationOccurred(.success)
                } else if newValue == .atLimit || newValue == .inProgress {
                    haptic.notificationOccurred(.warning)
                } else if newValue == .fail {
                    haptic.notificationOccurred(.error)
                }
            })
            .navigationTitle(date.formatted(.dateTime.day().month().year()))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.large)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            showEditSheet = true
                        } label: {
                            Text("Edit")
                        }
                        Button(role: .destructive, action: deleteTask) {
                            Text("Delete")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $showEditSheet) {
                EditHabitSheetView(existingHabit: habit)
            }
            .alert("Nice try, but you can't do a habit in the future!", isPresented: $showFutureEditAlert) {
                Button("Ok", role: .cancel, action: {})
            }
        }
    }
}

#Preview {
    return ContentView()
        .modelContainer(previewContainer)
}
