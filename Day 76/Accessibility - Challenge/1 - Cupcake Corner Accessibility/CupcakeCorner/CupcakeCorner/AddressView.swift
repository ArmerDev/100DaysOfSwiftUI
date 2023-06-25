//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by James Armer on 25/06/2023.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: SharedOrder
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.data.name)
                TextField("Street Address", text: $order.data.streetAddress)
                TextField("City", text: $order.data.city)
                TextField("Zip", text: $order.data.zip)
            }
            
            Section {
                NavigationLink {
                    CheckoutView(order: order)
                } label: {
                    Text("Check out")
                }
            }
            .disabled(order.data.hasValidAddress == false)
            
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddressView(order: SharedOrder())
        }
    }
}
