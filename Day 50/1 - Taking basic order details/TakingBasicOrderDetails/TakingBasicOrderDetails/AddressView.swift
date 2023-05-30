//
//  AddressView.swift
//  TakingBasicOrderDetails
//
//  Created by James Armer on 30/05/2023.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: Order
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

/*
 We’ll make AddressView more useful shortly, but for now it means we can return to ContentView.swift and add the final section for our form. This will create a NavigationLink that points to an AddressView, passing in the current order object.
 */

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
    }
}


