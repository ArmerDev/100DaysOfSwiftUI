//
//  AddressView.swift
//  CheckingForAValidAddress
//
//  Created by James Armer on 30/05/2023.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: Order
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
            }
            
            Section {
                NavigationLink {
                    CheckoutView(order: order)
                } label: {
                    Text("Check out")
                }
            }
            .disabled(order.hasValidAddress == false)
            
            /* Comment 2 -
             Now if you run the app you’ll see that all four address fields must contain at least one character in order to continue. Even better, SwiftUI automatically grays out the button when the condition isn’t true, giving the user really clear feedback when it is and isn’t interactive.
             */
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/* Comment 1 - 
 As you can see, that passes our order object on one level deeper, to CheckoutView, which means we now have three views pointing to the same data.

 Go ahead and run the app again, because I want you to see why all this matters. Enter some data on the first screen, enter some data on the second screen, then try navigating back to the beginning then forward to the end – that is, go back to the first screen, then click the bottom button twice to get to the checkout view again.

 What you should see is that all the data you entered stays saved no matter what screen you’re on. Yes, this is the natural side effect of using a class for our data, but it’s an instant feature in our app without having to do any work – if we had used a struct, then any address details we had entered would disappear if we moved back to the original view. If you really wanted to use a struct for your data, you should follow the same struct inside class approach we used back in project 7; it’s certainly worth keeping it in mind when you evaluate your options.

 Now that AddressView works, it’s time to stop the user progressing to the checkout unless some condition is satisfied. What condition? Well, that’s down to us to decide. Although we could write length checks for each of our four text fields, this often trips people up – some names are only four or five letters, so if you try to add length validation you might accidentally exclude people.

 So, instead we’re just going to check that the name, streetAddress, city, and zip properties of our order aren’t empty. I prefer adding this kind of complex check inside my data, which means you need to add a new computed property to Order, called hadValidAddress
 */

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddressView(order: Order())
        }
    }
}
