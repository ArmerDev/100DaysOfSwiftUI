//
//  ContentView.swift
//  PreparingForCheckout
//
//  Created by James Armer on 30/05/2023.
//

import SwiftUI

/*
 The final screen in our app is CheckoutView, and it’s really a tale of two halves: the first half is the basic user interface, which should provide little real challenge for you; but the second half is all new: we need to encode our Order class to JSON, send it over the internet, and get a response.

 We’re going to look at the whole encoding and transferring chunk of work soon enough, but first let’s tackle the easy part: giving CheckoutView a user interface. More specifically, we’re going to create a ScrollView with an image, the total price of their order, and a Place Order button to kick off the networking.

 For the image, I’ve uploaded a cupcake image to my server that we’ll load remotely with AsyncImage – we could store it in the app, but having a remote image means we can dynamically switch it out for seasonal alternatives and promotions.

 As for the order cost, we don’t actually have any pricing for our cupcakes in our data, so we can just invent one – it’s not like we’re actually going to be charging people here. The pricing we’re going to use is as follows:

 There’s a base cost of $2 per cupcake.
 We’ll add a little to the cost for more complicated cakes.
 Extra frosting will cost $1 per cake.
 Adding sprinkles will be another 50 cents per cake.
 We can wrap all that logic up in a new computed property for Order
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
