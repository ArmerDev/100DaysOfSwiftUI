//
//  ContentView.swift
//  HabitTracker
//
//  Created by James Armer on 29/05/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var habits = Habits()
    @State private var presentAddHabitSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(habits.habits) { habit in
                    NavigationLink {
                        HabitDetailView(habits: habits, habit: habit)
                    } label: {
                        Text(habit.name)
                    }

                }
            }
            .navigationTitle("Habit Tracker")
            .toolbar {
                Button {
                    presentAddHabitSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                }

            }
            .sheet(isPresented: $presentAddHabitSheet) {
                AddHabitView(habits: habits)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
