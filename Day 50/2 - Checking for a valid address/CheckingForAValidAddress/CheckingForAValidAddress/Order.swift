//
//  Order.swift
//  CheckingForAValidAddress
//
//  Created by James Armer on 30/05/2023.
//

import SwiftUI

/*
 First, we need four new @Published properties in Order to store delivery details:
 */

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
    
    @Published var name = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var zip = ""
    
    var hasValidAddress: Bool {
        if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
            return false
        }
        
        return true
    }
    
    /* Comment 2 -
     We can now use that condition in conjunction with SwiftUI’s disabled() modifier – attach that to any view along with a condition to check, and the view will stop responding to user interaction if the condition is true.

     In our case, the condition we want to check is the computed property we just wrote, hasValidAddress. If that is false, then the form section containing our NavigationLink ought to be disabled, because we need users to fill in their delivery details first.

     So, add this modifier to the end of the second section in AddressView:

     .disabled(order.hasValidAddress == false)
     */
    
}


/* Comment 1
 Now update the existing body of AddressView:
 */
