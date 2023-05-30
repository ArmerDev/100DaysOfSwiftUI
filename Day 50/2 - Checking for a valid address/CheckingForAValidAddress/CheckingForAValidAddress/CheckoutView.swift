//
//  CheckoutView.swift
//  CheckingForAValidAddress
//
//  Created by James Armer on 30/05/2023.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

/*
 Again, we’ll come back to that later, but first let’s implement AddressView. Like I said, this needs to have a form with four text fields bound to four properties from our Order object, plus a NavigationLink passing control off to our check out view.
 
    So navigate to the Order file
 */

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
