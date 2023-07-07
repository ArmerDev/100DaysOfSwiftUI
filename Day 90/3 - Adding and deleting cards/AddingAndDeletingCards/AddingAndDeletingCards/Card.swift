//
//  Card.swift
//  AddingAndDeletingCards
//
//  Created by James Armer on 07/07/2023.
//

import Foundation

struct Card: Codable {
    let prompt: String
    let answer: String
    
    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}
