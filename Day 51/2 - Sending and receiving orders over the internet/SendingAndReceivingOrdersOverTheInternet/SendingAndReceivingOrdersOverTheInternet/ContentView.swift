//
//  ContentView.swift
//  SendingAndReceivingOrdersOverTheInternet
//
//  Created by James Armer on 01/06/2023.
//

import SwiftUI

/*
 iOS comes with some fantastic functionality for handling networking, and in particular the URLSession class makes it surprisingly easy to send and receive data. If we combine that with Codable to convert Swift objects to and from JSON, we can use a new URLRequest struct to configure exactly how data should be sent, accomplishing great things in about 20 lines of code.

 First, let’s create a method we can call from our Place Order button in CheckoutView
 */

struct ContentView: View {
    @StateObject var order = Order()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $order.type) {
                        ForEach(Order.types.indices) {
                            Text(Order.types[$0])
                        }
                    }
                    
                    Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
                }
                
                Section {
                    Toggle("Any special requests?", isOn: $order.specialRequestEnabled.animation())
                    
                    if order.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $order.extraFrosting)
                        
                        Toggle("Add extra sprinkles", isOn: $order.addSprinkles)
                    }
                }
                
                Section {
                    NavigationLink {
                        AddressView(order: order)
                    } label: {
                        Text("Delivery details")
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
