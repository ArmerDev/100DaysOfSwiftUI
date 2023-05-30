//
//  CheckoutView.swift
//  PreparingForCheckout
//
//  Created by James Armer on 30/05/2023.
//

import SwiftUI

/*
 The actual view itself is straightforward: we’ll use a VStack inside a vertical ScrollView, then our image, the cost text, and button to place the order.

 We’ll be filling in the button’s action in a minute, but first let’s get the basic layout done – replace the existing body of CheckoutView with this:
 */

struct CheckoutView: View {
    @ObservedObject var order: Order
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                        image
                            .resizable()
                            .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)

                Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)

                Button("Place Order", action: { })
                    .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/*
 That should all be old news for you by now. But the tricky part comes tomorrow on Day 51
 */


struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
