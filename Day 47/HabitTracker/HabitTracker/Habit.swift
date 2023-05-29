//
//  Habit.swift
//  HabitTracker
//
//  Created by James Armer on 29/05/2023.
//

import Foundation

struct Habit: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let description: String
    var quantity: Int
}
