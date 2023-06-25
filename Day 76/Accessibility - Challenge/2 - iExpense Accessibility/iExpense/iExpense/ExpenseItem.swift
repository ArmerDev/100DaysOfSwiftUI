//
//  ExpenseItem.swift
//  iExpense
//
//  Created by James Armer on 25/06/2023.
//

import Foundation

struct ExpenseItem: Identifiable, Codable, Equatable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
