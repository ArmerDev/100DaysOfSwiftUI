//
//  Person.swift
//  WhoWasThat
//
//  Created by James Armer on 26/06/2023.
//

import SwiftUI

struct Person: Identifiable {
    let id = UUID()
    let name: String
    let picture: UIImage?
}
