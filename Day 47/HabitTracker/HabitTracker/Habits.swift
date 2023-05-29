//
//  Habits.swift
//  HabitTracker
//
//  Created by James Armer on 29/05/2023.
//

import Foundation

class Habits: ObservableObject {
    @Published var habits: [Habit] = [Habit(name: "Example Habit", description: "Example Description", quantity: 5)]
}
