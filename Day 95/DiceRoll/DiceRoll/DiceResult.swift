//
//  DiceResult.swift
//  DiceRoll
//
//  Created by James Armer on 14/07/2023.
//

import Foundation

struct DiceResult: Identifiable, Codable {
    var id = UUID()
    var type: Int
    var number: Int
    var rolls = [Int]()
    
    var description: String {
        rolls.map(String.init).joined(separator: ", ")
    }
    
    var rollTotal: Int {
        var total = 0
        
        for roll in rolls {
            total += roll
        }
        
        return total
    }
    
    init(type: Int, number: Int) {
        self.type = type
        self.number = number
        
        for _ in 0..<number {
            let roll = Int.random(in: 1...type)
            rolls.append(roll)
        }
    }
}
