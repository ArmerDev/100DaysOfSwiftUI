//
//  ContentView.swift
//  TakingBasicOrderDetails
//
//  Created by James Armer on 30/05/2023.
//

import SwiftUI

/*
 The first step in this project will be to create an ordering screen that takes the basic details of an order: how many cupcakes they want, what kind they want, and whether there are any special customizations.

 Before we get into the UI, we need to start by defining the data model. Previously we’ve used @State for simple value types and @StateObject for reference types, and we’ve looked at how it’s possible to have an ObservableObject class containing structs inside it so that we get the benefits of both.

 Here we’re going to take a different solution: we’re going to have a single class that stores all our data, which will be passed from screen to screen. This means all screens in our app share the same data, which will work really well as you’ll see.

 For now this class won’t need many properties:

 The type of cakes, plus a static array of all possible options.
 How many cakes the user wants to order.
 Whether the user wants to make special requests, which will show or hide extra options in our UI.
 Whether the user wants extra frosting on their cakes.
 Whether the user wants to add sprinkles on their cakes.
 Each of those need to update the UI when changed, which means we need to mark them with @Published and make the whole class conform to ObservableObject.

 So, please make a new Swift file called Order.swift, change its Foundation import for SwiftUI, and give it this code:

 class Order: ObservableObject {
     static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

     @Published var type = 0
     @Published var quantity = 3

     @Published var specialRequestEnabled = false
     @Published var extraFrosting = false
     @Published var addSprinkles = false
 }
 */

struct ContentView: View {
    @StateObject var order = Order()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

/*
 We’re going to build the UI for this screen in three sections, starting with cupcake type and quantity. This first section will show a picker letting users choose from Vanilla, Strawberry, Chocolate and Rainbow cakes, then a stepper with the range 3 through 20 to choose the amount. All that will be wrapped inside a form, which is itself inside a navigation view so we can set a title.

 There’s a small speed bump here: our cupcake topping list is an array of strings, but we’re storing the user’s selection as an integer – how can we match the two? One easy solution is to use the indices property of the array, which gives us a position of each item that we can then use with as an array index. This is a bad idea for mutable arrays because the order of your array can change at any time, but here our array order won’t ever change so it’s safe.
 */

struct ContentView2: View {
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
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

/*
 The second section of our form will hold three toggle switches bound to specialRequestEnabled, extraFrosting, and addSprinkles respectively. However, the second and third switches should only be visible when the first one is enabled, so we’ll wrap then in a condition.
 */

struct ContentView3: View {
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
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

/*
 Go ahead and run the app again, and try it out – notice how I bound the first toggle with an animation() modifier attached, so that the second and third toggles slide in and out smoothly.

 However, there’s another bug, and this time it’s one of our own making: if we enable special requests then enable one or both of “extra frosting” and “extra sprinkles”, then disable the special requests, our previous special request selection stays active. This means if we re-enable special requests, the previous special requests are still active.

 This kind of problem isn’t hard to work around if every layer of your code is aware of it – if the app, your server, your database, and so on are all programmed to ignore the values of extraFrosting and addSprinkles when specialRequestEnabled is set to false. However, a better idea – a safer idea – is to make sure that both extraFrosting and addSprinkles are reset to false when specialRequestEnabled is set to false.

 We can make this happen by adding the below didSet property observer to specialRequestEnabled in the Order file.
 
 @Published var specialRequestEnabled = false {
     didSet {
         if specialRequestEnabled == false {
             extraFrosting = false
             addSprinkles = false
         }
     }
 }
 
 */

/*
 
 Our third section is the easiest, because it’s just going to be a NavigationLink pointing to the next screen. We don’t have a second screen, but we can add it quickly enough: create a new SwiftUI view called “AddressView”, and give it an order observed object property
 */

struct ContentView4: View {
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


/*
 That completes our first screen, so give it a try one last time before we move on – you should be able to select your cake type, choose a quantity, and toggle all the switches just fine.
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView3()
            .previewDisplayName("ContentView 3")
        ContentView4()
            .previewDisplayName("ContentView 4")
    }
}
