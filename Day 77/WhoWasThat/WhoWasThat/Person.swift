//
//  Person.swift
//  WhoWasThat
//
//  Created by James Armer on 26/06/2023.
//

import SwiftUI

struct Person: Identifiable, Codable {
    var id = UUID()
    let name: String
    let picture: Data
    
    init(name: String, picture: UIImage) {
        self.name = name
        self.picture = picture.pngData()!
    }
}
