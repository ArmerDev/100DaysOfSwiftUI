//
//  Order.swift
//  TakingBasicOrderDetails
//
//  Created by James Armer on 30/05/2023.
//

import SwiftUI

class Order: ObservableObject {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    @Published var type = 0
    @Published var quantity = 3
    
    @Published var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    @Published var extraFrosting = false
    @Published var addSprinkles = false
}

/*
 We can now create a single instance of that inside ContentView by adding this property:

 @StateObject var order = Order()
 
 That’s the only place the order will be created – every other screen in our app will be passed that property so they all work with the same data.
 */
