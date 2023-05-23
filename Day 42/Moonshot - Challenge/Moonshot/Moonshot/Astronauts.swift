//
//  Astronauts.swift
//  Moonshot
//
//  Created by James Armer on 23/05/2023.
//

import Foundation

struct Astronaut: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
}
