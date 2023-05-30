//
//  ContentView.swift
//  CheckingForAValidAddress
//
//  Created by James Armer on 30/05/2023.
//

import SwiftUI

/*
 The second step in our project will be to let the user enter their address into a form, but as part of that we’re going to add some validation – we only want to proceed to the third step if their address looks good.

 We can accomplish this by adding a Form view to the AddressView struct we made previously, which will contain four text fields: name, street address, city, and zip. We can then add a NavigationLink to move to the next screen, which is where the user will see their final price and can check out.

 To make this easier to follow, we’re going to start by adding a new view called CheckoutView, which is where this address view will push to once the user is ready. This just avoids us having to put a placeholder in now then remember to come back later.

 So, create a new SwiftUI view called CheckoutView and give it the same Order observed object property and preview that AddressView has:
 
 struct CheckoutView: View {
     @ObservedObject var order: Order

     var body: some View {
         Text("Hello, World!")
     }
 }

 struct CheckoutView_Previews: PreviewProvider {
     static var previews: some View {
         CheckoutView(order: Order())
     }
 }
 
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
