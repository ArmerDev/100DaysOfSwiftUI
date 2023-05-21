//
//  ExpenseItem.swift
//  iExpense
//
//  Created by James Armer on 21/05/2023.
//

import Foundation

struct ExpenseItem: Identifiable, Codable, Equatable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
